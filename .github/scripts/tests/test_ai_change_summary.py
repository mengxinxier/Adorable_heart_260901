from __future__ import annotations

import importlib.util
import json
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

SCRIPT_DIR = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "ai_change_summary", SCRIPT_DIR / "ai_change_summary.py"
)
assert SPEC and SPEC.loader
ai = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = ai
SPEC.loader.exec_module(ai)


class RedactionTests(unittest.TestCase):
    def test_redacts_common_tokens(self) -> None:
        text = (
            "ghp_" + "a" * 24 + "\n"
            "sk-" + "b" * 24 + "\n"
            "AKIA" + "C" * 16 + "\n"
            "xoxb-" + "1234567890" + "\n"
            "password=super-secret\n"
        )
        result = ai.redact_secrets(text)
        self.assertNotIn("a" * 24, result)
        self.assertNotIn("b" * 24, result)
        self.assertNotIn("C" * 16, result)
        self.assertNotIn("super-secret", result)
        self.assertIn("[REDACTED_", result)

    def test_redacts_json_secret_fields(self) -> None:
        text = '{"api_key": "abc123", "password": "hunter2"}'
        result = ai.redact_secrets(text)
        self.assertNotIn("abc123", result)
        self.assertNotIn("hunter2", result)
        self.assertEqual(result.count("[REDACTED]"), 2)

    def test_redacts_private_key_block(self) -> None:
        text = (
            "-----BEGIN RSA PRIVATE KEY-----\n"
            "very-secret-body\n"
            "-----END RSA PRIVATE KEY-----"
        )
        self.assertEqual(ai.redact_secrets(text), "[REDACTED_PRIVATE_KEY]")


class JsonTests(unittest.TestCase):
    def test_extracts_json_from_code_fence(self) -> None:
        parsed = ai.extract_json_object(
            '```json\n{"title": "x", "summary": "y"}\n```'
        )
        self.assertEqual(parsed["title"], "x")

    def test_extracts_json_from_surrounding_text(self) -> None:
        parsed = ai.extract_json_object(
            '下面是结果：\n{"title": "x", "changes": []}\n谢谢'
        )
        self.assertEqual(parsed["changes"], [])

    def test_invalid_json_raises(self) -> None:
        with self.assertRaises(ai.SummaryError):
            ai.extract_json_object("no json here")


class SummaryTests(unittest.TestCase):
    def test_normalize_drops_html_and_caps_lists(self) -> None:
        raw = {
            "title": "<script>alert(1)</script>标题",
            "summary": "概述",
            "changes": [
                {"area": "api", "description": "<b>修复</b>接口"},
                "x",
            ],
            "impact": ["a"] * 20,
            "verification": ["pytest"],
            "risks": [],
        }
        result = ai.normalize_summary(raw)
        self.assertNotIn("<script>", result["title"])
        self.assertNotIn("<b>", result["changes"][0]["description"])
        self.assertEqual(len(result["impact"]), 8)

    def test_placeholder_description_detection(self) -> None:
        for value in ["", "1", "111", "test", "修改", "更新", "  111  "]:
            self.assertTrue(ai.looks_like_placeholder_description(value), value)
        for value in [
            "修复登录接口 token 刷新逻辑",
            "本次更新调整了 PAU 国策树并补充本地化",
            "https://github.com/example/repo/pull/1",
        ]:
            self.assertFalse(ai.looks_like_placeholder_description(value), value)

    def test_normalize_reads_meaningless_description_flag(self) -> None:
        result = ai.normalize_summary(
            {
                "title": "测试",
                "summary": "测试",
                "description_is_meaningless": True,
            }
        )
        self.assertTrue(result["description_is_meaningless"])

    def test_upsert_preserves_human_text_and_replaces_once(self) -> None:
        old_block = f"{ai.SUMMARY_START}\nold\n{ai.SUMMARY_END}"
        new_block = f"{ai.SUMMARY_START}\nnew\n{ai.SUMMARY_END}"
        existing = f"人工填写的说明\n\n{old_block}"
        updated = ai.upsert_marker(existing, new_block)
        self.assertIn("人工填写的说明", updated)
        self.assertIn("\nnew\n", updated)
        self.assertNotIn("\nold\n", updated)
        self.assertEqual(ai.upsert_marker(updated, new_block), updated)

    def test_render_contains_sections_and_cannot_break_marker(self) -> None:
        change = ai.ChangeSet(
            event_name="pull_request_target",
            title="测试",
            identifier="PR #1",
            files=[ai.FileChange("a.py", additions=1, deletions=2, patch="+x")],
        )
        summary = {
            "title": "修复",
            "summary": f"注入 {ai.SUMMARY_END} 文本",
            "changes": [{"area": "a.py", "description": "改了逻辑"}],
            "impact": ["接口"],
            "verification": ["运行测试"],
            "risks": [],
        }
        block = ai.render_summary(summary, change, "test-model", "")
        self.assertTrue(block.startswith(ai.SUMMARY_START))
        self.assertTrue(block.endswith(ai.SUMMARY_END))
        self.assertEqual(block.count(ai.SUMMARY_END), 1)
        self.assertIn("### 主要改动", block)
        self.assertIn("建议验证", block)


class ChangePayloadTests(unittest.TestCase):
    def test_sensitive_and_generated_files_are_not_sent(self) -> None:
        with patch.dict(os.environ, {"MAX_DIFF_CHARS": "1000"}, clear=False):
            changes = ai.build_file_changes(
                [
                    {
                        "filename": ".env",
                        "status": "modified",
                        "additions": 1,
                        "deletions": 0,
                        "patch": "+LLM_API_KEY=secret",
                    },
                    {
                        "filename": "package-lock.json",
                        "status": "modified",
                        "additions": 5,
                        "deletions": 5,
                        "patch": "+lock",
                    },
                    {
                        "filename": "src/main.py",
                        "status": "modified",
                        "additions": 1,
                        "deletions": 0,
                        "patch": "+print('ok')",
                    },
                ]
            )
        self.assertFalse(changes[0].patch)
        self.assertIn("敏感", changes[0].omitted_reason)
        self.assertFalse(changes[1].patch)
        self.assertIn("生成", changes[1].omitted_reason)
        self.assertEqual(changes[2].patch, "+print('ok')")
        self.assertTrue(any(item.patch for item in changes))

    def test_deterministic_summary_groups_status(self) -> None:
        change = ai.ChangeSet(
            event_name="push",
            title="提交标题",
            identifier="commit abc",
            commits=[{"message": "提交标题", "author": "dev"}],
            files=[
                ai.FileChange("a.py", status="added", additions=3),
                ai.FileChange("b.py", status="modified", additions=1, deletions=1),
            ],
            truncated=True,
        )
        summary = ai.deterministic_summary(change)
        self.assertIn("2 个文件", summary["summary"])
        self.assertEqual(len(summary["changes"]), 2)


class FakeHttpResponse:
    def __init__(self, payload: dict) -> None:
        self._body = json.dumps(payload).encode("utf-8")

    def read(self) -> bytes:
        return self._body

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, traceback) -> bool:
        return False


class MainFlowTests(unittest.TestCase):
    def test_pull_request_event_updates_pr_body(self) -> None:
        event = {
            "pull_request": {
                "number": 7,
                "title": "更新功能",
                "head": {
                    "repo": {"full_name": "acme/repo"},
                    "sha": "headsha",
                },
                "base": {"sha": "basesha"},
            }
        }
        pr = {
            "number": 7,
            "title": "更新功能",
            "body": "人工填写的背景说明",
            "state": "open",
            "head": {"repo": {"full_name": "acme/repo"}, "sha": "headsha"},
            "base": {"sha": "basesha"},
        }
        files = [
            {
                "filename": "src/app.py",
                "status": "modified",
                "additions": 2,
                "deletions": 1,
                "patch": "+new_line\n-old_line",
            }
        ]
        commits = [{"commit": {"message": "更新逻辑", "author": {"name": "dev"}}}]
        captured_patch = {}

        def fake_urlopen(request, timeout=0):
            url = request.full_url
            method = request.get_method()
            if url.startswith("https://api.github.com/repos/acme/repo/pulls/7/files"):
                return FakeHttpResponse(files)
            if url.startswith("https://api.github.com/repos/acme/repo/pulls/7/commits"):
                return FakeHttpResponse(commits)
            if url.startswith("https://api.github.com/repos/acme/repo/pulls/7"):
                if method == "PATCH":
                    captured_patch.update(json.loads(request.data.decode("utf-8")))
                    return FakeHttpResponse({"number": 7})
                return FakeHttpResponse(pr)
            if url == "https://llm.example/v1/chat/completions":
                content = json.dumps(
                    {
                        "title": "更新应用逻辑",
                        "summary": "调整了应用逻辑。",
                        "changes": [{"area": "src", "description": "修改 app.py"}],
                        "impact": ["应用行为"],
                        "verification": ["运行测试"],
                        "risks": [],
                    },
                    ensure_ascii=False,
                )
                return FakeHttpResponse(
                    {"choices": [{"message": {"content": content}}]}
                )
            raise AssertionError(f"unexpected request: {method} {url}")

        with tempfile.TemporaryDirectory() as tmp:
            event_path = Path(tmp) / "event.json"
            event_path.write_text(json.dumps(event), encoding="utf-8")
            with patch.dict(
                os.environ,
                {
                    "GITHUB_TOKEN": "gh-token",
                    "GITHUB_REPOSITORY": "acme/repo",
                    "GITHUB_EVENT_NAME": "pull_request_target",
                    "GITHUB_EVENT_PATH": str(event_path),
                    "LLM_API_KEY": "test-key",
                    "LLM_BASE_URL": "https://llm.example/v1",
                    "LLM_MODEL": "test-model",
                },
                clear=False,
            ), patch("urllib.request.urlopen", side_effect=fake_urlopen):
                exit_code = ai.main()

        self.assertEqual(exit_code, 0)
        body = captured_patch.get("body", "")
        self.assertIn("人工填写的背景说明", body)
        self.assertIn(ai.SUMMARY_START, body)
        self.assertIn("更新应用逻辑", body)


    def test_push_without_pr_posts_commit_comment(self) -> None:
        event = {
            "before": "abc123",
            "after": "def456",
            "ref": "refs/heads/feature/demo",
            "head_commit": {"commit": {"message": "演示推送"}},
        }
        compare = {
            "total_commits": 1,
            "commits": [
                {"commit": {"message": "演示推送", "author": {"name": "dev"}}}
            ],
            "files": [
                {
                    "filename": "src/app.py",
                    "status": "modified",
                    "additions": 1,
                    "deletions": 0,
                    "patch": "+new_line",
                }
            ],
        }
        captured_comment = {}

        def fake_urlopen(request, timeout=0):
            url = request.full_url
            method = request.get_method()
            if url.startswith("https://api.github.com/repos/acme/repo/commits/def456/pulls"):
                return FakeHttpResponse([])
            if url.startswith("https://api.github.com/repos/acme/repo/compare/abc123...def456"):
                return FakeHttpResponse(compare)
            if url.startswith("https://api.github.com/repos/acme/repo/commits/def456/comments"):
                if method == "POST":
                    captured_comment.update(json.loads(request.data.decode("utf-8")))
                    return FakeHttpResponse({"id": 1})
                return FakeHttpResponse([])
            if url == "https://llm.example/v1/chat/completions":
                content = json.dumps(
                    {
                        "title": "演示推送",
                        "summary": "修改了应用。",
                        "changes": [{"area": "src", "description": "新增一行"}],
                        "impact": [],
                        "verification": [],
                        "risks": [],
                    },
                    ensure_ascii=False,
                )
                return FakeHttpResponse(
                    {"choices": [{"message": {"content": content}}]}
                )
            raise AssertionError(f"unexpected request: {method} {url}")

        with tempfile.TemporaryDirectory() as tmp:
            event_path = Path(tmp) / "event.json"
            event_path.write_text(json.dumps(event), encoding="utf-8")
            with patch.dict(
                os.environ,
                {
                    "GITHUB_TOKEN": "gh-token",
                    "GITHUB_REPOSITORY": "acme/repo",
                    "GITHUB_EVENT_NAME": "push",
                    "GITHUB_EVENT_PATH": str(event_path),
                    "LLM_API_KEY": "test-key",
                    "LLM_BASE_URL": "https://llm.example/v1",
                    "LLM_MODEL": "test-model",
                },
                clear=False,
            ), patch("urllib.request.urlopen", side_effect=fake_urlopen):
                exit_code = ai.main()

        self.assertEqual(exit_code, 0)
        body = captured_comment.get("body", "")
        self.assertIn(ai.SUMMARY_START, body)
        self.assertIn("演示推送", body)


class EndpointTests(unittest.TestCase):
    def test_chat_completions_url_normalization(self) -> None:
        with patch.dict(os.environ, {"LLM_BASE_URL": "https://example.com/v1"}):
            self.assertEqual(
                ai._chat_completions_url(),
                "https://example.com/v1/chat/completions",
            )
        with patch.dict(os.environ, {"LLM_BASE_URL": "https://example.com"}):
            self.assertEqual(
                ai._chat_completions_url(),
                "https://example.com/v1/chat/completions",
            )
        with patch.dict(
            os.environ, {"LLM_BASE_URL": "https://example.com/custom/chat/completions"}
        ):
            self.assertEqual(
                ai._chat_completions_url(),
                "https://example.com/custom/chat/completions",
            )

    def test_call_llm_parses_model_json(self) -> None:
        change = ai.ChangeSet(
            event_name="pull_request_target",
            title="测试 PR",
            identifier="PR #2",
            files=[ai.FileChange("a.py", additions=1, patch="+x = 1")],
        )
        captured = {}

        def fake_urlopen(request, timeout=0):
            captured["url"] = request.full_url
            captured["auth"] = request.get_header("Authorization")
            captured["body"] = json.loads(request.data.decode("utf-8"))
            content = json.dumps(
                {
                    "title": "修复逻辑",
                    "summary": "调整了变量。",
                    "changes": [{"area": "a.py", "description": "新增变量"}],
                    "impact": [],
                    "verification": ["检查变量"],
                    "risks": [],
                },
                ensure_ascii=False,
            )
            return FakeHttpResponse(
                {"choices": [{"message": {"content": content}}]}
            )

        with patch.dict(
            os.environ,
            {
                "LLM_API_KEY": "test-key",
                "LLM_BASE_URL": "https://example.com/v1",
                "LLM_MODEL": "test-model",
            },
            clear=False,
        ), patch("urllib.request.urlopen", side_effect=fake_urlopen):
            result = ai.call_llm(change)

        self.assertEqual(captured["url"], "https://example.com/v1/chat/completions")
        self.assertEqual(captured["auth"], "Bearer test-key")
        self.assertEqual(captured["body"]["model"], "test-model")
        self.assertEqual(result["title"], "修复逻辑")
        self.assertNotIn("test-key", json.dumps(captured["body"]))


if __name__ == "__main__":
    unittest.main()

# AI 改动说明 / 自动提交信息

这个仓库现在有两层自动化：

1. **本地提交前**：`prepare-commit-msg` 钩子发现提交信息是空的或类似 `1`、`111`、`test`、`update` 时，先让 AI 判断，确认是占位符后再根据暂存区 diff 改写成中文提交说明。
2. **上传到 GitHub 后**：GitHub Actions 分析 PR 的 diff，直接更新 PR 描述；直接 push 没有 PR 时只写 GitHub Actions 运行摘要，不创建 commit 评论、不额外发通知邮件。PR 原描述如果是 `111` 这种占位符，也会被 AI 判定后替换。

> Git 的 commit message 一旦推送就无法安全改写；要改提交记录本身，必须在推送前由本地钩子写入。Action 只负责更新 PR 描述或 Actions 运行摘要，不通过评论/邮件来“补记录”。

## 当前仓库已配置

- GitHub Actions Secret：`LLM_API_KEY`（加密保存，不在仓库里）
- GitHub Actions Variables：
  - `LLM_BASE_URL` = `https://token-plan.maas.qianwenaiapi.com/compatible-mode/v1`
  - `LLM_MODEL` = `qwen3.8-flash`
  - `SUMMARY_LANGUAGE` = `zh-CN`
  - `LLM_MAX_TOKENS` = `3000`
- 本机用户环境变量已设置 `LLM_API_KEY` / `LLM_BASE_URL` / `LLM_MODEL`
- 当前 clone 已执行 `git config core.hooksPath .githooks`

## 本地钩子用法

新 clone 或换电脑后，先执行：

```bash
git config core.hooksPath .githooks
```

或：

```bash
python .github/scripts/install_hooks.py
```

然后正常提交即可：

```bash
git add .
git commit -m "111"
```

如果 AI 判定 `111` 是占位符，会自动改成类似：

```text
新增应用入口脚本

- 新建 app.py 文件
- 添加启动逻辑
```

如果提交信息本身是正常的中文/英文说明，本地不会调用 API，原样保留。

### 团队共用一个 API Key（推荐）

每台电脑只需要安装一次。合作者先 `git pull`，然后双击：

```text
.github\scripts\setup_windows.cmd
```

或在 PowerShell 中运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .github/scripts/setup_windows.ps1
```

脚本会：

- 自动执行 `git config core.hooksPath .githooks`
- 检查 Python 和钩子文件
- 提示粘贴团队共用的 `LLM_API_KEY`（输入不回显）
- 把 `LLM_API_KEY` / `LLM_BASE_URL` / `LLM_MODEL` 写入当前 Windows 用户环境变量
- 测试模型接口是否可用

密钥只存在合作者本机的用户环境变量里，不会进入 Git 仓库。需要注意：共用 Key 意味着所有使用者的调用额度和费用都算在同一个 Key 上，任何能登录那台电脑的人也可能读到该环境变量；如果 Key 外泄，应在服务商后台轮换。

### 手动配置环境变量

钩子只从环境变量读取密钥，不会读取仓库里的文件：

```powershell
# PowerShell：当前用户永久生效（把 <你的 key> 换成实际值，不要提交）
[Environment]::SetEnvironmentVariable("LLM_API_KEY", "<你的 key>", "User")
[Environment]::SetEnvironmentVariable("LLM_BASE_URL", "https://token-plan.maas.qianwenaiapi.com/compatible-mode/v1", "User")
[Environment]::SetEnvironmentVariable("LLM_MODEL", "qwen3.8-flash", "User")
```

设置后需要新开终端 / 重启 Git GUI 才会读到新环境变量。

临时关闭钩子：

```bash
SKIP_AI_COMMIT_MSG=1 git commit -m "111"
# 或
git commit --no-verify -m "111"
```

预演不写文件：

```powershell
$env:AI_COMMIT_MSG_DRY_RUN="1"
git commit -m "111"
```

## GitHub Actions 行为

| 事件 | 行为 |
| --- | --- |
| 新建/更新 PR | 分析 PR diff，更新 PR 描述里的 AI 区块 |
| push 且没有 PR | 分析 push 前后 diff，写入 GitHub Actions 运行摘要（不评论） |
| push 且已有 PR | 默认交给 `pull_request_target` 的 synchronize 处理，直接更新 PR 描述 |
| PR 评论 `/ai-describe` 或 `/ai-summary` | 仓库成员/合作者可手动重新生成 |

PR 的 AI 区块使用标记保存，重复执行原地替换，人工写在区块外的正常内容会保留。只有 AI 明确判定原描述是 `111`、空白、`test` 之类占位符，并且内容确实很短时，才会整体替换，避免误删真正的背景说明。

直接 push 的摘要显示在：GitHub → Actions → 对应运行记录 → Summary。它不会像 commit comment 那样触发额外邮件通知。

## 安全设计

- API Key 只来自环境变量 / GitHub Secrets，代码中没有任何密钥。
- `.gitignore` 排除了 `.env`、`*.key`、`*.pem`、`secrets.*` 等。
- fork PR 默认不发送代码到外部 API。
- `.env`、私钥、证书、`credentials` 等敏感文件不发送内容。
- 发送前对 GitHub / OpenAI / AWS / Slack 等常见 token 做脱敏。
- 不执行 PR 或功能分支里的代码；Action 只读取 GitHub API 返回的 diff。
- API 失败时本地钩子保留原提交信息，Action 回退到基础文件统计，不阻塞提交。

注意：启用后，暂存区/PR 的 diff 会发送到配置的外部模型服务。私有内容请确认服务商数据政策，或把 `LLM_BASE_URL` 指向自建模型。

## 配置项

| 名称 | 默认值 | 说明 |
| --- | --- | --- |
| `LLM_API_KEY` | 无 | 必填，只放环境变量/Secret |
| `LLM_BASE_URL` | 本仓库默认千问兼容接口 | 模型 API 地址 |
| `LLM_MODEL` | `qwen3.8-flash` | 模型名 |
| `SUMMARY_LANGUAGE` | `zh-CN` | 输出语言 |
| `LLM_MAX_TOKENS` | `3000` | Action 最大输出 token |
| `AI_COMMIT_MSG_MAX_TOKENS` | `1800` | 本地钩子最大输出 token |
| `MAX_FILES` | `80` | 最多分析文件数 |
| `MAX_FILE_PATCH_CHARS` | `12000` | 单文件 diff 上限 |
| `MAX_DIFF_CHARS` | `60000` | 总 diff 上限 |
| `SKIP_FORK_PRS` | `true` | fork PR 默认跳过 |
| `SKIP_PUSH_WITH_OPEN_PR` | `true` | 有关联 PR 的 push 交给 PR 事件 |
| `FAIL_ON_ERROR` | `false` | API 失败是否让 Action 标红 |

## 测试

```bash
python -m unittest discover -s .github/scripts/tests -v
```

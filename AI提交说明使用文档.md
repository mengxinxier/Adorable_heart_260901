# AI 提交说明使用文档（组员版）

适用仓库：`Adorable_heart_260901`

这个功能用来解决提交信息只写 `1`、`111`、`test`、`update` 的问题：

- 提交前如果信息是空的或明显是占位符，会先让 AI 判断
- AI 确认没意义后，根据暂存区 diff 自动改写成中文提交说明
- 正常写的中文/英文提交信息不会被改
- 每个组员第一次使用时需要安装一次

> 注意：GitHub 上已经推送的旧提交不能安全修改；这个工具只负责**以后的新提交**。

---

## 一、一次性安装

### 准备

1. Windows 电脑
2. 已安装 Git
3. 已安装 Python 3.10 或更高版本，并且 `python` 命令可用
4. 先拉取仓库最新代码
5. 向希尔私聊获取团队共用的 `LLM_API_KEY`，不要发到群文件或提交到仓库

### 步骤

#### 1. 更新仓库

打开 Git Bash、PowerShell 或 VS Code 终端：

```bash
cd "C:\1\HOI MOD\Paradox Interactive\Hearts of Iron IV\mod\Adorable_heart_260901"
git pull
```

#### 2. 运行一键安装

在资源管理器里双击：

```text
.github\scripts\setup_windows.cmd
```

如果双击没反应，可以在 PowerShell 里运行：

```powershell
cd "C:\1\HOI MOD\Paradox Interactive\Hearts of Iron IV\mod\Adorable_heart_260901"
powershell -NoProfile -ExecutionPolicy Bypass -File .github/scripts/setup_windows.ps1
```

脚本会依次：

1. 启用仓库里的 Git 钩子
2. 检查 Python
3. 提示你粘贴团队 API Key，输入内容不会显示
4. 把 Key 和接口地址写入当前 Windows 用户环境变量
5. 测试接口是否可用

Key 只会存在你的电脑上，不会进入 Git 仓库。

#### 3. 新开终端

安装完成后，必须**关闭当前终端和 Git GUI，再重新打开**，否则读不到新的环境变量。

检查钩子是否启用：

```bash
git config --get core.hooksPath
```

应该输出：

```text
.githooks
```

#### 4. 测试

随便改一个文本文件，然后提交一个假信息：

```bash
git add .
git commit -m "111"
```

如果看到类似下面的提示，就说明安装成功：

```text
AI 提交说明：已将“111”改写为“新增 AI 提交说明安装文档”
```

可以用下面的命令确认最终提交信息：

```bash
git log -1
```

---

## 二、日常使用

### 正常提交

照常写代码、`git add`、`git commit` 即可。

如果提交信息写得正常，比如：

```bash
git commit -m "修复 PAU 国策树本地化文本"
```

工具不会调用 AI，也不会改你的提交信息。

### 写得太随意

如果写成：

```bash
git commit -m "111"
```

或者：

```bash
git commit -m "更新"
```

AI 会先判断，确认是占位符后结合暂存区改动生成中文提交说明。

### 想跳过 AI

只跳过这一次：

```bash
git commit --no-verify -m "111"
```

本次终端会话内全部跳过：

```bash
export SKIP_AI_COMMIT_MSG=1
```

Windows CMD：

```cmd
set SKIP_AI_COMMIT_MSG=1
```

### 只看 AI 会怎么改，不实际写入

PowerShell：

```powershell
$env:AI_COMMIT_MSG_DRY_RUN="1"
git commit -m "111"
```

---

## 三、GitHub 网页提交和 PR

- GitHub 网页上直接提交会绕过本地钩子，**不会自动改 commit message**
- 本地钩子只能管本机 `git commit`
- 如果通过 PR 上传，GitHub Actions 会自动更新 PR 描述
- 直接 push 时只写 GitHub Actions 运行摘要，不创建 commit 评论，不额外发通知邮件

---

## 四、常见问题

### 1. 提示“未配置 LLM_API_KEY”

说明当前终端没有读到 Key。

处理方法：

1. 重新运行 `.github/scripts/setup_windows.cmd`
2. 关闭并重新打开终端、VS Code 或 GitHub Desktop
3. 再试一次

### 2. 双击 `.cmd` 没反应或闪退

用 PowerShell 手动运行：

```powershell
cd "C:\1\HOI MOD\Paradox Interactive\Hearts of Iron IV\mod\Adorable_heart_260901"
powershell -NoProfile -ExecutionPolicy Bypass -File .github/scripts/setup_windows.ps1
```

### 3. 安装时 API 测试失败

脚本仍然会保存环境变量，可以先检查：

- 网络是否正常
- 代理是否影响访问
- Key 是否复制完整
- 是否多复制了空格或换行

确认后重新运行安装脚本即可。

### 4. 提交时提示“暂存区没有可分析的文本改动”

说明这次只暂存了二进制文件，比如：

- `.dds`
- `.png`
- `.psd`
- `.mesh`
- 其他生成文件

没有文本 diff，AI 无法判断改了什么，所以会保留原提交信息。把相关的文本文件也 `git add` 后再提交即可。

### 5. 钩子没有执行

检查：

```bash
git config --get core.hooksPath
```

如果不是 `.githooks`，重新运行：

```bash
python .github/scripts/install_hooks.py
```

### 6. 使用 VS Code / GitHub Desktop

安装完成后请重启软件，让它们继承新的用户环境变量。

---

## 五、安全要求

1. **不要把 API Key 提交到仓库**
2. **不要发到公开群、Issue、PR 或截图里**
3. 不要把 Key 写进 `.env`、脚本或文档后再提交
4. Key 只通过私聊或密码管理器分发
5. 团队共用 Key 的费用和额度都算在同一个 Key 上
6. 如果 Key 外泄，立即联系希尔到服务商后台轮换

---

## 六、最短流程

```text
1. git pull
2. 双击 .github\scripts\setup_windows.cmd
3. 粘贴团队 API Key
4. 新开终端
5. 正常 git add / git commit
```

有问题直接找希尔。

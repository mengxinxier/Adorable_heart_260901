[CmdletBinding()]
param(
    [string]$Provider = "",
    [string]$BaseUrl = "",
    [string]$Model = "",
    [switch]$SkipApiTest
)

$ErrorActionPreference = "Stop"
try {
    chcp 65001 > $null
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
}
catch {
    # 旧版 PowerShell/终端不支持时忽略，不影响安装逻辑。
}
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
Set-Location $repoRoot

$presets = [ordered]@{
    "1" = @{ Key = "deepseek"; Name = "DeepSeek 官方"; BaseUrl = "https://api.deepseek.com/v1"; Model = "deepseek-chat" }
    "2" = @{ Key = "qwen"; Name = "通义千问兼容模式"; BaseUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1"; Model = "qwen-plus" }
    "3" = @{ Key = "openai"; Name = "OpenAI 官方"; BaseUrl = "https://api.openai.com/v1"; Model = "gpt-4o-mini" }
    "4" = @{ Key = "glm"; Name = "智谱 GLM 兼容接口"; BaseUrl = "https://open.bigmodel.cn/api/paas/v4"; Model = "glm-4-flash" }
    "5" = @{ Key = "custom"; Name = "自定义 OpenAI 兼容接口"; BaseUrl = ""; Model = "" }
}

Write-Host ""
Write-Host "=== AI 提交说明一键安装 ===" -ForegroundColor Cyan
Write-Host "仓库：$repoRoot"

if (-not (Test-Path ".git")) {
    throw "当前目录不是 Git 仓库：$repoRoot"
}
if (-not (Test-Path ".githooks\prepare-commit-msg")) {
    throw "缺少 .githooks\prepare-commit-msg，请先 git pull 最新代码"
}

git config core.hooksPath .githooks
if ($LASTEXITCODE -ne 0) {
    throw "设置 core.hooksPath 失败"
}
Write-Host "[1/4] 已启用 .githooks/prepare-commit-msg" -ForegroundColor Green

$selected = $null
if ($Provider) {
    $selected = $presets.Values | Where-Object { $_.Key -eq $Provider.ToLower() } | Select-Object -First 1
    if (-not $selected) {
        throw "未知厂商：$Provider。可选 deepseek / qwen / openai / glm / custom"
    }
}
elseif ($BaseUrl -and $Model) {
    $selected = @{ Key = "custom"; Name = "自定义"; BaseUrl = $BaseUrl; Model = $Model }
}
else {
    Write-Host ""
    Write-Host "请选择 API 厂商：" -ForegroundColor Cyan
    foreach ($entry in $presets.GetEnumerator()) {
        Write-Host "  $($entry.Key). $($entry.Value.Name)"
    }
    $choice = Read-Host "输入编号 [1-5]，直接回车使用 1"
    if (-not $choice) { $choice = "1" }
    if (-not $presets.Contains($choice)) {
        throw "无效的厂商编号：$choice"
    }
    $selected = $presets[$choice]
}

if ($selected.BaseUrl) { $BaseUrl = $selected.BaseUrl }
if ($selected.Model) { $Model = $selected.Model }

if (-not $BaseUrl) {
    $BaseUrl = Read-Host "请输入 LLM_BASE_URL，例如 https://api.example.com/v1"
}
if (-not $Model) {
    $Model = Read-Host "请输入 LLM_MODEL，例如 gpt-4o-mini"
}
if (-not $BaseUrl -or -not $Model) {
    throw "LLM_BASE_URL 或 LLM_MODEL 为空，安装中止"
}

Write-Host "已选择：$($selected.Name)" -ForegroundColor Green
Write-Host "  LLM_BASE_URL = $BaseUrl"
Write-Host "  LLM_MODEL    = $Model"

$existingKey = [Environment]::GetEnvironmentVariable("LLM_API_KEY", "User")
if ($existingKey) {
    $replace = Read-Host "检测到已配置 LLM_API_KEY，是否替换？输入 y 替换，直接回车保留"
    if ($replace -eq "y") {
        $existingKey = $null
    }
}

if (-not $existingKey) {
    $secureKey = Read-Host "请粘贴该厂商的 LLM_API_KEY（输入不回显）" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
    try {
        $existingKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

if (-not $existingKey) {
    throw "API Key 为空，安装中止"
}

[Environment]::SetEnvironmentVariable("LLM_API_KEY", $existingKey, "User")
[Environment]::SetEnvironmentVariable("LLM_BASE_URL", $BaseUrl, "User")
[Environment]::SetEnvironmentVariable("LLM_MODEL", $Model, "User")
$env:LLM_API_KEY = $existingKey
$env:LLM_BASE_URL = $BaseUrl
$env:LLM_MODEL = $Model
Write-Host "[2/4] 已写入 Windows 用户环境变量（密钥不会进入 Git 仓库）" -ForegroundColor Green

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "未找到 python，请先安装 Python 3.10+ 并加入 PATH"
}
Write-Host "[3/4] Python：$($python.Source)" -ForegroundColor Green

if (-not $SkipApiTest) {
    $testBase = $BaseUrl.TrimEnd('/')
    if ($testBase -match "/chat/completions") {
        Write-Host "[4/4] 自定义完整 chat/completions 地址，跳过 /models 测试" -ForegroundColor Yellow
    }
    else {
        try {
            $headers = @{
                Authorization = "Bearer $existingKey"
                Accept = "application/json"
                "User-Agent" = "ai-change-summary-setup"
            }
            $null = Invoke-RestMethod -Uri "$testBase/models" -Headers $headers -TimeoutSec 30
            Write-Host "[4/4] API 连接测试成功" -ForegroundColor Green
        }
        catch {
            Write-Warning "[4/4] API 连接测试失败：$($_.Exception.Message)"
            Write-Warning "环境变量已经写入；可以稍后检查网络、代理、Key 或模型权限"
        }
    }
}
else {
    Write-Host "[4/4] 已跳过 API 连接测试" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "安装完成。" -ForegroundColor Cyan
Write-Host "请新开一个终端，然后测试："
Write-Host "  git add ."
Write-Host '  git commit -m "111"'
Write-Host ""
Write-Host "如果看到“AI 提交说明：已将...改写为...”，说明钩子已生效。"
Write-Host '临时跳过：git commit --no-verify -m "111"'

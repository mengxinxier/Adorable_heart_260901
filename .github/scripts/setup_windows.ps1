[CmdletBinding()]
param(
    [string]$BaseUrl = "https://token-plan.maas.qianwenaiapi.com/compatible-mode/v1",
    [string]$Model = "qwen3.8-flash",
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

$existingKey = [Environment]::GetEnvironmentVariable("LLM_API_KEY", "User")
if ($existingKey) {
    $replace = Read-Host "检测到已配置 LLM_API_KEY，是否替换？输入 y 替换，直接回车保留"
    if ($replace -eq "y") {
        $existingKey = $null
    }
}

if (-not $existingKey) {
    $secureKey = Read-Host "请粘贴团队共用的 LLM_API_KEY（输入不回显）" -AsSecureString
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
Write-Host "      LLM_BASE_URL = $BaseUrl"
Write-Host "      LLM_MODEL    = $Model"

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "未找到 python，请先安装 Python 3.10+ 并加入 PATH"
}
Write-Host "[3/4] Python：$($python.Source)" -ForegroundColor Green

if (-not $SkipApiTest) {
    try {
        $headers = @{
            Authorization = "Bearer $existingKey"
            Accept = "application/json"
            "User-Agent" = "ai-change-summary-setup"
        }
        $null = Invoke-RestMethod -Uri "$($BaseUrl.TrimEnd('/'))/models" -Headers $headers -TimeoutSec 30
        Write-Host "[4/4] API 连接测试成功" -ForegroundColor Green
    }
    catch {
        Write-Warning "[4/4] API 连接测试失败：$($_.Exception.Message)"
        Write-Warning "环境变量已经写入；可以稍后检查网络、代理或 Key 是否有效"
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

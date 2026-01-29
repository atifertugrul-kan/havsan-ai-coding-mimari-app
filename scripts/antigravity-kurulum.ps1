# ============================================
# HAVSAN Antigravity - Kurulum ve Guncelleme
# ============================================
try {
    # Helper Functions (One-liners)
    function Log-H($m) { Write-Host "`n"; Write-Host "=== $m ===" -F Magenta }
    function Log-S($m) { Write-Host "`n"; Write-Host "[OK] $m" -F Green }
    function Log-I($m) { Write-Host "`n"; Write-Host "[INFO] $m" -F Cyan }
    function Log-W($m) { Write-Host "`n"; Write-Host "[WARN] $m" -F Yellow }
    function Log-E($m) { Write-Host "`n"; Write-Host "[ERROR] $m" -F Red }
    function Log-D($m) { Write-Host "`n"; Write-Host "[DEBUG] $m" -F DarkGray }

    # Maximize Window
    $def = '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);'
    $w32 = Add-Type -MemberDefinition $def -Name "Win32" -Namespace Win32 -PassThru
    $h = (Get-Process -Id $PID).MainWindowHandle; if ($h -ne [IntPtr]::Zero) { $w32::ShowWindow($h, 3) }

    Clear-Host
    $global:total = 7; $global:step = 0

    function Upd-Prog($act) {
        $global:step++; $p = 0; if ($global:total -gt 0) { $p = [math]::Round(($global:step / $global:total) * 100) }
        $w = 30; $f = [math]::Round(($p / 100) * $w); $bar = "|" * $f + " " * ($w - $f)
        Write-Host -NoNewline ("`r[$bar] $p% - $act").PadRight(120, " "); if ($p -ge 100) { Write-Host "" }
    }

    # ASCII Art
    Write-Host @'
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_|
                                         
      Robotik & Yapay Zeka
      v2.1.8 (Pause Fix)
'@ -F Cyan
    Write-Host "    Atif Ertugrul Kan`n    Kurumsal Gelistirici Altyapi Mimari & HAVSAN CTO`n" -F Yellow
    Log-H "HAVSAN Antigravity Kurulum"

    # Paths
    $ROOT = Split-Path -Parent $PSScriptRoot
    $SRC = "$ROOT\gemini"; $TGT = "$env:USERPROFILE\.gemini"
    Log-I "Kaynak: $SRC"; Log-I "Hedef: $TGT"

    # Step 0: Git Update
    Upd-Prog "Git Pull"; Log-H "0. Git Guncelleme"
    if (Test-Path "$ROOT\.git") { 
        $out = git -C "$ROOT" pull 2>&1; Write-Host $out -F Gray
        if ($LASTEXITCODE -eq 0) { Log-S "Guncellendi" } else { Log-W "Git hatasi, yerelle devam." }
    }

    # Step 1: Checks
    Upd-Prog "Hedef Kontrol"; Log-H "1. Ortam Kontrolu"
    if (!(Test-Path $SRC)) { throw "Kaynak yok: $SRC" }
    if (!(Test-Path $TGT)) { New-Item -Type Directory -Force $TGT | Out-Null; $isUpd = $false } else { Log-S "Hedef mevcut"; $isUpd = $true }

    # Helper for Safe Copy
    function Copy-Safe($s, $d, $rec = $false) {
        if (Test-Path $s) { 
            if ($rec) { if (Test-Path $d) { Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue }; Copy-Item $s $d -Recurse -Force } 
            else { Copy-Item $s $d -Force }
            Log-S "$(Split-Path $s -Leaf) kopyalandi"
            return 1
        }
        return 0
    }

    # Step 2: Backup
    Upd-Prog "Yedekleme"; Log-H "2. Yedekleme"
    $prefix = if ($isUpd) { "guncelleme" } else { "kurulum" }
    $bDir = "$TGT\backups\${prefix}_oncs_$(Get-Date -F 'yyyyMMdd_HHmmss')"
    New-Item -Type Directory -Force $bDir | Out-Null
    
    Copy-Safe "$TGT\GEMINI.md" "$bDir\GEMINI.md"
    if (Test-Path "$TGT\antigravity") { New-Item -Type Directory -Force "$bDir\antigravity" | Out-Null }
    Copy-Safe "$TGT\antigravity\skills" "$bDir\antigravity\skills" $true
    Copy-Safe "$TGT\antigravity\workflows" "$bDir\antigravity\workflows" $true

    # Step 3: Install
    Upd-Prog "Dosya Kopyalama"; Log-H "3. Dosyalar Yukleniyor"
    $cnt = 0
    $cnt += Copy-Safe "$SRC\GEMINI.dist.md" "$TGT\GEMINI.md"
    $cnt += Copy-Safe "$SRC\KURULUM.md" "$TGT\KURULUM.md"
    
    if (!(Test-Path "$TGT\antigravity")) { New-Item -Type Directory -Force "$TGT\antigravity" | Out-Null }
    $cnt += Copy-Safe "$SRC\antigravity\skills" "$TGT\antigravity\skills" $true
    $cnt += Copy-Safe "$SRC\antigravity\workflows" "$TGT\antigravity\workflows" $true

    Upd-Prog "Tamamlandi"

    if ($cnt -gt 0) {
        Log-H "ISLEM BASARILI! (v2.1.7 Yuklendi)"
        Write-Host "`n1. Antigravity IDE'ye git`n2. 'Refresh Rules' ve 'Refresh Workflows' yap`n" -F Cyan
    }
    else { Log-E "Dosya kopyalanamadi!" }

}
catch { 
    Write-Host "`n"
    Write-Host "[ERROR] HATA: $($_.Exception.Message)" -F Red 
    Write-Host "[ERROR] $($_.ScriptStackTrace)" -F Red
}

Write-Host "`nCikis icin ENTER..." -F Yellow; Read-Host

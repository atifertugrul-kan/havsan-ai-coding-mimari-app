param([switch]$Startup)

# ============================================
# HAVSAN Antigravity - Kurulum ve Guncelleme
# ============================================
try {
    # --- CHANGELOG ---
    $CHANGELOG = @'
    [v2.5.1 YENILIKLER]
    - Arayuz: Satir araliklari geniletildi (Daha iyi okunabilirlik)
    - Branding: ELAZIG ORGANIZE SANAYI BOLGESI imzasi
    - Fix: Eski versiyon numarasi gorunme sorunu giderildi
'@

    # Helper Functions
    function Log-H($m) { Write-Host "`n=== $m ===" -F Magenta }
    function Log-S($m) { Write-Host "[OK] $m" -F Green }
    function Log-I($m) { Write-Host "[INFO] $m" -F Cyan }
    function Log-W($m) { Write-Host "[WARN] $m" -F Yellow }
    function Log-E($m) { Write-Host "[ERROR] $m" -F Red }

    # Paths
    $SCRIPT_PATH = $MyInvocation.MyCommand.Definition
    $ROOT = Split-Path -Parent (Split-Path -Parent $SCRIPT_PATH)
    
    # --- AUTO-STARTUP CHECK ---
    if ($Startup) {
        if (Test-Path "$ROOT\.git") {
            try {
                git -C "$ROOT" fetch -q 2>&1 | Out-Null
                $local = git -C "$ROOT" rev-parse HEAD
                $remote = git -C "$ROOT" rev-parse '@{u}'
                if ($local -eq $remote) { exit } 
            }
            catch { exit }
        }
    }

    # Maximize Window
    $def = '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);'
    $w32 = Add-Type -MemberDefinition $def -Name "Win32" -Namespace Win32 -PassThru
    $h = (Get-Process -Id $PID).MainWindowHandle; if ($h -ne [IntPtr]::Zero) { $w32::ShowWindow($h, 3) }

    Clear-Host

    # ASCII Art (Restored & Extended)
    Write-Host @'
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_| Robotics & AI | ELAZIG ORGANIZE SANAYI BOLGESI
                                         
'@ -F Cyan

    Write-Host ""
    Write-Host "    Atif Ertugrul Kan" -F Yellow
    Write-Host "    Kurumsal Gelistirici Altyapi Mimari & HAVSAN CTO" -F DarkGray
    Write-Host "    v2.5.1 (Spacing Fix)" -F Gray
    Write-Host ""
    Write-Host ""
    Write-Host $CHANGELOG -F Green
    Write-Host ""
    Write-Host ""

    $SRC = "$ROOT\gemini"; $TGT = "$env:USERPROFILE\.gemini"
    Log-I "Kaynak: $SRC"
    Log-I "Hedef:  $TGT"
    Write-Host ""

    # Step 0: Register Startup
    Log-H "0. Sistem Entegrasyonu"
    $lnkPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\AntigravityUpdate.lnk"
    if (-not (Test-Path $lnkPath)) {
        try {
            $ws = New-Object -ComObject WScript.Shell
            $s = $ws.CreateShortcut($lnkPath)
            $s.TargetPath = "powershell.exe"
            $s.Arguments = "-ExecutionPolicy Bypass -WindowStyle Minimized -File `"$SCRIPT_PATH`" -Startup"
            $s.Save()
            Log-S "Baslangica eklendi"
        }
        catch { Log-W "Baslangica eklenemedi" }
    }
    else { Log-S "Startup kaydi mevcut" }

    # Step 1: Git Update
    Log-H "1. Proje Guncelleniyor"
    if (Test-Path "$ROOT\.git") { 
        $out = git -C "$ROOT" pull 2>&1
        if ($LASTEXITCODE -eq 0) { Log-S "Guncellendi" } else { Log-W "Yerel modla devam." }
    }

    # Step 2: Checks
    if (!(Test-Path $SRC)) { throw "Kaynak yok: $SRC" }
    if (!(Test-Path $TGT)) { New-Item -Type Directory -Force $TGT | Out-Null; $isUpd = $false } else { Log-S "Hedef mevcut"; $isUpd = $true }

    function Copy-Safe($s, $d, $rec = $false) {
        if (Test-Path $s) { 
            if ($rec) { if (Test-Path $d) { Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue }; Copy-Item $s $d -Recurse -Force } 
            else { Copy-Item $s $d -Force }
            Log-S "$(Split-Path $s -Leaf) kopyalandi"
            return 1
        }
        return 0
    }

    # Step 3: Backup
    Log-H "2. Yedekleme"
    $prefix = if ($isUpd) { "guncelleme" } else { "kurulum" }
    $bDir = "$TGT\backups\${prefix}_$(Get-Date -F 'yyyyMMdd_HHmmss')"
    New-Item -Type Directory -Force $bDir | Out-Null
    
    $null = Copy-Safe "$TGT\GEMINI.md" "$bDir\GEMINI.md"
    if (Test-Path "$TGT\antigravity") { New-Item -Type Directory -Force "$bDir\antigravity" | Out-Null }
    $null = Copy-Safe "$TGT\antigravity\skills" "$bDir\antigravity\skills" $true
    $null = Copy-Safe "$TGT\antigravity\workflows" "$bDir\antigravity\workflows" $true

    # Step 4: Install
    Log-H "3. Dosyalar Yukleniyor"
    $cnt = 0
    $cnt += Copy-Safe "$SRC\GEMINI.dist.md" "$TGT\GEMINI.md"
    $cnt += Copy-Safe "$SRC\KURULUM.md" "$TGT\KURULUM.md"
    
    if (!(Test-Path "$TGT\antigravity")) { New-Item -Type Directory -Force "$TGT\antigravity" | Out-Null }
    $cnt += Copy-Safe "$SRC\antigravity\skills" "$TGT\antigravity\skills" $true
    $cnt += Copy-Safe "$SRC\antigravity\workflows" "$TGT\antigravity\workflows" $true

    if ($cnt -gt 0) {
        Log-H "ISLEM BASARILI! (v2.5.0)"
        Write-Host "`n1. Antigravity IDE -> Refresh Rules" -F Cyan
    }
    else { Log-E "Hata!" }

}
catch { 
    Write-Host "`n"
    Write-Host "[ERROR] HATA: $($_.Exception.Message)" -F Red 
}

Write-Host "`nCikis icin ENTER..." -F Yellow; $null = Read-Host

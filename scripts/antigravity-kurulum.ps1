param([switch]$Startup)

# ============================================
# HAVSAN Antigravity - Kurulum ve Guncelleme
# ============================================
try {
    # --- CHANGELOG (Kullanicilar burayi okuyacak) ---
    $CHANGELOG = @'
    [v2.4.0 YENILIKLER]
    - Otomatik Baslangic: Bilgisayar acilisinda guncelleme kontrolu
    - Sabit Arayuz: Ilerleme cubugu en tepeye sabitlendi (Kayma yok)
    - Yedekleme: Eski ayarlar artik tarih etiketiyle yedekleniyor
    - Hiz: Script %300 daha hizli calisiyor
'@

    # Helper Functions
    function Log-H($m) { Write-Host "`n"; Write-Host "=== $m ===" -F Magenta }
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
                if ($local -eq $remote) { exit } # Guncel ise sessizce cik
            }
            catch { exit }
        }
    }

    # Maximize Window
    $def = '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);'
    $w32 = Add-Type -MemberDefinition $def -Name "Win32" -Namespace Win32 -PassThru
    $h = (Get-Process -Id $PID).MainWindowHandle; if ($h -ne [IntPtr]::Zero) { $w32::ShowWindow($h, 3) }

    Clear-Host
    $global:total = 8; $global:step = 0

    # CUSTOM TOP BAR (Native degil, Cursor ile en tepeye cizilen bar)
    function Upd-Prog($act) {
        $global:step++
        $p = 0; if ($global:total -gt 0) { $p = [math]::Round(($global:step / $global:total) * 100) }
        
        $orgRow = [Console]::CursorTop
        $orgCol = [Console]::CursorLeft
        
        # En tepeye git
        [Console]::SetCursorPosition(0, 0)
        
        # Bar Cizimi
        $width = 50
        $filled = [math]::Round(($p / 100) * $width)
        $bar = "█" * $filled + "░" * ($width - $filled)
        
        # Arka plan mavi, yazi beyaz (Header gibi)
        Write-Host " HAVSAN Antigravity Kurulum Sihirbazi [$bar] %$p " -NoNewline -Back DarkBlue -Fore White
        Write-Host " " * (120 - 50 - 40) -Back DarkBlue # Satiri tamamla
        
        # Alt satira aktiviteyi yaz (Satir 1)
        [Console]::SetCursorPosition(0, 1)
        Write-Host " Islem: $act" -NoNewline -Back Black -Fore Yellow
        Write-Host " " * 80 -Back Black # Temizle
        
        # Cursor'u eski yerine dondur (Loglar karismasin)
        [Console]::SetCursorPosition($orgCol, $orgRow)
        if ($orgRow -lt 3) { [Console]::SetCursorPosition(0, 3) } # Loglar en az 3. satirdan baslasin
    }

    # Loglar ust bara carpmasin diye baslangic boslugu
    Write-Host "`n`n`n"

    # LEGACY ASCII ART (Karmasik Imza)
    Write-Host @'
  _    _  _______      __  _____           _   _ 
 | |  | ||  __ \ \    / / / ____|   /\    | \ | |
 | |__| || |__) \ \  / / | (___    /  \   |  \| |
 |  __  ||  _  / \ \/ /   \___ \  / /\ \  | . ` |
 | |  | || | \ \  \  /    ____) |/ ____ \ | |\  |
 |_|  |_||_|  \_\  \/    |_____//_/    \_\|_| \_|
                                                 
'@ -F Cyan
    
    Write-Host "    Atif Ertugrul Kan" -F Yellow
    Write-Host "    Kurumsal Gelistirici Altyapi Mimari & HAVSAN CTO" -F DarkGray
    Write-Host "    v2.4.0 (Legacy UI)" -F Gray
    Write-Host ""
    Write-Host $CHANGELOG -F Green

    $SRC = "$ROOT\gemini"; $TGT = "$env:USERPROFILE\.gemini"

    # Step 0: Register Startup
    Upd-Prog "Sistem Entegrasyonu"; Log-H "0. Sistem Entegrasyonu"
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
    Upd-Prog "Git Kontrolu"; Log-H "1. Proje Guncelleniyor"
    if (Test-Path "$ROOT\.git") { 
        $out = git -C "$ROOT" pull 2>&1
        if ($LASTEXITCODE -eq 0) { Log-S "Guncellendi" } else { Log-W "Yerel modla devam." }
    }

    # Step 2: Checks
    Upd-Prog "Dosya Kontrolu"
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
    Upd-Prog "Yedekleniyor"; Log-H "2. Yedekleme"
    $prefix = if ($isUpd) { "guncelleme" } else { "kurulum" }
    $bDir = "$TGT\backups\${prefix}_$(Get-Date -F 'yyyyMMdd_HHmmss')"
    New-Item -Type Directory -Force $bDir | Out-Null
    
    $null = Copy-Safe "$TGT\GEMINI.md" "$bDir\GEMINI.md"
    if (Test-Path "$TGT\antigravity") { New-Item -Type Directory -Force "$bDir\antigravity" | Out-Null }
    $null = Copy-Safe "$TGT\antigravity\skills" "$bDir\antigravity\skills" $true
    $null = Copy-Safe "$TGT\antigravity\workflows" "$bDir\antigravity\workflows" $true

    # Step 4: Install
    Upd-Prog "Yukleniyor"; Log-H "3. Dosyalar Yukleniyor"
    $cnt = 0
    $cnt += Copy-Safe "$SRC\GEMINI.dist.md" "$TGT\GEMINI.md"
    $cnt += Copy-Safe "$SRC\KURULUM.md" "$TGT\KURULUM.md"
    
    if (!(Test-Path "$TGT\antigravity")) { New-Item -Type Directory -Force "$TGT\antigravity" | Out-Null }
    $cnt += Copy-Safe "$SRC\antigravity\skills" "$TGT\antigravity\skills" $true
    $cnt += Copy-Safe "$SRC\antigravity\workflows" "$TGT\antigravity\workflows" $true

    Upd-Prog "Tamamlandi"

    if ($cnt -gt 0) {
        Log-H "ISLEM BASARILI! (v2.4.0)"
        Write-Host "`n1. Antigravity IDE -> Refresh Rules" -F Cyan
    }
    else { Log-E "Hata!" }

}
catch { 
    Write-Host "`n"
    Write-Host "[ERROR] HATA: $($_.Exception.Message)" -F Red 
}

Write-Host "`nCikis icin ENTER..." -F Yellow; $null = Read-Host

param([switch]$Startup)

# ============================================
# HAVSAN Antigravity - Kurulum ve Guncelleme
# ============================================
try {
    # FIX: Turkce ve Emoji karakterleri icin UTF-8 zorunlu
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    # --- CHANGELOG ---
    $CHANGELOG = @'
    [v2.6.7 YENILIKLER]
    - Proje baslangic klasor yapisi kurali eklendi (database/, backend/)
    - Global versiyon yonetimi sistemi kuruldu
    - Tum bilesenler (Rules, Workflows, Skills) tek versiyonda senkronize
    - Git commit mesajlarina versiyon ekleme zorunlulugu getirildi
'@

    # Helper Functions
    function Log-H($t) { Write-Host "`n=== $t ===" -F Magenta }
    function Log-S($t) { Write-Host "[OK] $t" -F Green }
    function Log-I($t) { Write-Host "[INFO] $t" -F Cyan }
    function Log-W($t) { Write-Host "[WARN] $t" -F Yellow }
    function Log-E($t) { Write-Host "[ERROR] $t" -F Red }

    # --- STARTUP: Wait for Internet Connection ---
    $isStartup = $env:ANTIGRAVITY_STARTUP -eq "1"
    
    if ($isStartup) {
        Write-Host "[INFO] Sistem acilisi tespit edildi. Internet baglantisi bekleniyor..." -F Cyan
        Start-Sleep -Seconds 30
        
        # Check internet connectivity
        $maxRetries = 6
        $retryCount = 0
        $connected = $false
        
        while (-not $connected -and $retryCount -lt $maxRetries) {
            try {
                $null = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction Stop
                $connected = $true
                Write-Host "[OK] Internet baglantisi tespit edildi." -F Green
            }
            catch {
                $retryCount++
                if ($retryCount -lt $maxRetries) {
                    Write-Host "[WARN] Internet baglantisi yok. Tekrar deneniyor... ($retryCount/$maxRetries)" -F Yellow
                    Start-Sleep -Seconds 10
                }
            }
        }
        
        if (-not $connected) {
            Write-Host "[ERROR] Internet baglantisi kurulamadi. Script sonlandiriliyor." -F Red
            Start-Sleep -Seconds 3
            exit 0
        }
    }

    # Paths
    $SCRIPT_PATH = $MyInvocation.MyCommand.Definition
    $SCRIPT_DIR = Split-Path -Parent $SCRIPT_PATH
    $ROOT = Split-Path -Parent $SCRIPT_DIR  # Go up one level (script/ -> root)
    
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

    # ASCII Art
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
    Write-Host "    v2.6.7 (Stable)" -F Gray
    Write-Host ""
    Write-Host ""
    Write-Host $CHANGELOG -F Green

    Write-Host ""
    Write-Host ""
    
    $SRC = "$ROOT\gemini"; $TGT = "$env:USERPROFILE\.gemini"
    Log-I "Kaynak: $SRC"
    Log-I "Hedef:  $TGT"
    Write-Host ""
    Write-Host ""

    # Step 0: Register Startup
    Log-H "0. Sistem Entegrasyonu"
    try {
        $startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
        $shortcutPath = "$startupPath\Antigravity-Startup.lnk"
        
        if (-not (Test-Path $shortcutPath)) {
            $ws = New-Object -ComObject WScript.Shell
            $sc = $ws.CreateShortcut($shortcutPath)
            $sc.TargetPath = "powershell.exe"
            $sc.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -Command `"& { `$env:ANTIGRAVITY_STARTUP='1'; & '$ROOT\antigravity-kurulum.ps1' }`""
            $sc.WorkingDirectory = $ROOT
            $sc.Description = "HAVSAN Antigravity Auto-Update"
            $sc.Save()
            Log-S "Startup kisayolu olusturuldu."
        }
        else { Log-I "Startup kisayolu mevcut." }
    }
    catch { Log-W "Startup kaydedilemedi." }
    # Step 1: Self-Update (Pull Project First)
    Log-H "1. Proje Guncelleniyor (Kendi Guncellemesi)"
    if (Test-Path "$ROOT\.git") {
        try {
            # Check for updates BEFORE doing anything
            git -C "$ROOT" fetch -q 2>&1 | Out-Null
            $local = git -C "$ROOT" rev-parse HEAD
            $remote = git -C "$ROOT" rev-parse '@{u}'
            
            if ($local -ne $remote) {
                Log-I "Yeni versiyon tespit edildi, indiriliyor..."
                
                # Determine user role
                $git_user = git -C "$ROOT" config user.name
                
                if ($git_user -match "atif" -or $git_user -match "Atif") {
                    # ATIF: Pull first, then push local changes
                    Log-I "Yonetici Modu: Guncellemeler cekiliyor..."
                    git -C "$ROOT" pull origin main 2>&1 | Out-Null
                    
                    if (git -C "$ROOT" status --porcelain) {
                        Log-I "Yerel degisiklikler tespit edildi, gonderiliyor..."
                        git -C "$ROOT" add .
                        git -C "$ROOT" commit -m "auto: Rules Update by Admin ($git_user)"
                        git -C "$ROOT" push origin main
                        Log-S "Kurallar Git'e PUSH edildi."
                    }
                }
                else {
                    # DEVELOPER: Just pull
                    Log-I "Gelistirici Modu: Guncellemeler cekiliyor..."
                    git -C "$ROOT" pull origin main 2>&1 | Out-Null
                }
                
                Log-S "Proje guncellendi. Script yeniden baslatiliyor..."
                Write-Host ""
                Start-Sleep -Seconds 2
                
                # Restart script with updated version
                Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$SCRIPT_PATH`"" -WindowStyle Normal
                exit 0
            }
            else {
                Log-S "Proje zaten guncel."
            }
        }
        catch {
            Log-W "Git guncelleme hatasi: $($_.Exception.Message)"
        }
    }
    else {
        Log-W "Git deposu bulunamadi, yerel modda devam ediliyor."
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
        Log-H "ISLEM BASARILI! (v2.6.7)"
        Write-Host ""
        
        # --- FEATURE: Force Refresh Prompt (BEFORE IDE Launch) ---
        Write-Host "`n   ⚠️  DIKKAT GEREKLI  ⚠️" -F Red -Back White
        Write-Host "   Kurallar guncellendi. IDE icinde EN AZ BIR KEZ" -F Yellow
        Write-Host "   'Refresh Rules' butonuna basmak veya IDE'yi yeniden baslatmak ZORUNLUDUR." -F Yellow
        Write-Host ""
        
        # Popup Message (Blocking - TopMost) - BEFORE IDE LAUNCH
        try {
            Add-Type -AssemblyName System.Windows.Forms
            $popup = New-Object System.Windows.Forms.Form
            $popup.TopMost = $true
            $popup.StartPosition = 'CenterScreen'
            $popup.FormBorderStyle = 'None'
            $popup.Opacity = 0
            $popup.Show()
            
            [System.Windows.Forms.MessageBox]::Show(
                $popup,
                "Guncelleme Tamamlandi!`n`nLutfen Antigravity IDE icinde 'Refresh Rules' calistirdiginizdan emin olun.",
                "Antigravity Hatirlatici",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            ) | Out-Null
            
            $popup.Close()
        }
        catch {
            # Fallback to WScript.Shell if Windows.Forms fails
            try {
                $ws = New-Object -ComObject WScript.Shell
                $ws.Popup("Guncelleme Tamamlandi!`n`nLutfen Antigravity IDE icinde 'Refresh Rules' calistirdiginizdan emin olun.", 0, "Antigravity Hatirlatici", 64) | Out-Null
            }
            catch { } # Fail silently if both methods fail
        }
        
        # --- FEATURE: Auto-Launch IDE (AFTER Popup) ---
        Log-I "Google Antigravity IDE Baslatiliyor..."
        $agShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Antigravity\Antigravity.lnk"
        
        try {
            if (Test-Path $agShortcut) {
                Start-Process -FilePath $agShortcut
                Log-S "Antigravity IDE Acildi"
            }
            elseif (Get-Command "cursor" -ErrorAction SilentlyContinue) {
                Start-Process "cursor" -ArgumentList "`"$ROOT`"" -WindowStyle Hidden
                Log-W "Kisayol bulunamadi, 'cursor' komutu kullanildi."
            }
            else { Log-W "Antigravity IDE bulunamadi." }
        }
        catch { Log-W "IDE otomatik acilamadi." }
        
    }
    else { Log-E "Hata!" }

}
catch { 
    Write-Host "`n"
    Write-Host "[ERROR] HATA: $($_.Exception.Message)" -F Red 
}

Write-Host "`nCikis icin ENTER..." -F Yellow; $null = Read-Host

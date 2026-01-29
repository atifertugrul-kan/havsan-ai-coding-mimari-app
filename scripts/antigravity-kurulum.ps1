# ============================================
# HAVSAN Antigravity - Kurulum ve Guncelleme
# ============================================
# Kullanim: Sag Tik -> Run with PowerShell
# ============================================

# Pencerenin hemen kapanmamasi icin hata yakalama blogu
try {
    # Renkli konsol ciktisi fonksiyonlari
    function Write-Header { param([string]$msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta }
    function Write-Success { param([string]$msg) Write-Host "[OK] $msg" -ForegroundColor Green }
    function Write-Info { param([string]$msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
    function Write-Warning { param([string]$msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
    function Write-Error { param([string]$msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }
    function Write-Debug { param([string]$msg) Write-Host "[DEBUG] $msg" -ForegroundColor DarkGray }

    
    # ==========================================
    # PENCEREYI TAM EKRAN YAP (Maximize)
    # ==========================================
    $memberDefinition = @'
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'@
    $win32 = Add-Type -MemberDefinition $memberDefinition -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru
    $hwnd = (Get-Process -Id $PID).MainWindowHandle
    if ($hwnd -ne [IntPtr]::Zero) { $win32::ShowWindow($hwnd, 3) } # 3 = SW_MAXIMIZE

    Clear-Host
    
    # Global degiskenleri en basta tanimla
    $global:totalSteps = 7
    $global:currentStep = 0

    function Update-Progress {
        param([string]$activity)
        $global:currentStep++
        if ($global:totalSteps -gt 0) {
            $percent = [math]::Round(($global:currentStep / $global:totalSteps) * 100)
        }
        else {
            $percent = 0
        }

        # Progress Bar Gorseli
        $width = 30
        $filled = [math]::Round(($percent / 100) * $width)
        $empty = $width - $filled
        $bar = "|" * $filled + " " * $empty
        
        # Satir ici guncelleme (Carriage Return `r)
        # Metni 120 karaktere tamamlayarak (PadRight) eski yazilari temizle
        $msg = "`r[$bar] $percent% - $activity"
        $paddedMsg = $msg.PadRight(120, " ")
        Write-Host -NoNewline $paddedMsg
        
        # Eger %100 ise yeni satira gec
        if ($percent -ge 100) { Write-Host "" }
    }
    
    # Logo Yazdirma (Here-String ile bozulmayi onle)
    $logo = @'
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_|
                                         
      Robotik & Yapay Zeka
      v2.1.5 (Clean Bar)
    
'@
    Write-Host $logo -ForegroundColor Cyan

    Write-Host "    Atif Ertugrul Kan" -ForegroundColor Yellow
    Write-Host "    Kurumsal Gelistirici Altyapi Mimari & HAVSAN CTO" -ForegroundColor DarkGray
    Write-Host ""
    Write-Header "HAVSAN Antigravity Kurulum ve Guncelleme"

    Write-Host "Bu sihirbaz ne yapiyor?" -ForegroundColor Yellow
    Write-Host "1. Antigravity IDE kurallarini (Rules, Skills, Workflows) yukler veya gunceller." -ForegroundColor Gray
    Write-Host "2. Proje standartlarinin herkes icin ayni olmasini saglar." -ForegroundColor Gray
    Write-Host "3. Eski ayarlari otomatik yedekler." -ForegroundColor Gray
    Write-Host "4. Projeyi Git sunucusundan otomatik gunceller." -ForegroundColor Gray
    Write-Host ""

    # Dizinleri Belirleme
    $SCRIPT_DIR = $PSScriptRoot
    $PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR
    $SOURCE_DIR = "$PROJECT_ROOT\gemini"
    $TARGET_DIR = "$env:USERPROFILE\.gemini"
    
    # Progress bar fonksiyonu yukarida tanimlandi


    Write-Info "Calisma Dizini: $PROJECT_ROOT"
    Write-Info "Kaynak Klasor:  $SOURCE_DIR"
    Write-Info "Hedef Klasor:   $TARGET_DIR"

    # ============================================
    # Adim 0: Git Guncelleme (Otomatik Pull)
    # ============================================
    Update-Progress "Git Pull yapiliyor"
    Write-Header "0. Proje Guncelleniyor (Git Pull)"
    
    if (Test-Path "$PROJECT_ROOT\.git") {
        try {
            Write-Info "Git deposu algilandi, guncelleme kontrol ediliyor..."
            # Git command outputunu yakalamak icin
            $gitOutput = git -C "$PROJECT_ROOT" pull 2>&1
            Write-Host $gitOutput -ForegroundColor Gray
            
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Proje en son versiyona guncellendi."
            }
            else {
                Write-Warning "Git pull sirasinda bir uyari/hata olustu. Yerel dosyalarla devam ediliyor."
            }
        }
        catch {
            Write-Warning "Git komutu calistirilamadi. Git yuklu mu?"
        }
    }
    else {
        Write-Warning "Bu klasor bir Git deposu degil. Guncelleme atlandi."
    }

    # ============================================
    # Adim 1: Kontroller
    # ============================================
    Update-Progress "Hedef kontrol ediliyor"
    Write-Header "1. Ortam Kontrolu"

    if (-not (Test-Path $SOURCE_DIR)) {
        throw "Kaynak klasor bulunamadi! Beklenen: $SOURCE_DIR"
    }

    if (-not (Test-Path $TARGET_DIR)) {
        Write-Warning "Antigravity IDE klasoru bulunamadi."
        Write-Info "Klasor olusturuluyor..."
        New-Item -ItemType Directory -Force -Path $TARGET_DIR | Out-Null
        $isUpdate = $false
    }
    else {
        Write-Success "Hedef klasor mevcut (Guncelleme Modu)."
        $isUpdate = $true
    }

    # ============================================
    # Adim 2: Yedekleme
    # ============================================
    Update-Progress "Yedekleme yapiliyor"
    Write-Header "2. Yedekleme"

    $timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $actionType = if ($isUpdate) { "guncelleme" } else { "kurulum" }
    $BACKUP_DIR = "$TARGET_DIR\backups\${actionType}_oncesi_$timestamp"
    
    Write-Debug "Yedek klasoru olusturuluyor: $BACKUP_DIR"
    New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null

    # GEMINI.md Yedekle
    if (Test-Path "$TARGET_DIR\GEMINI.md") { 
        Write-Debug "GEMINI.md yedekleniyor..."
        Copy-Item "$TARGET_DIR\GEMINI.md" "$BACKUP_DIR\GEMINI.md" -Force -Confirm:$false
        Write-Success "Eski GEMINI.md yedeklendi"
    }

    # SADECE skills ve workflows klasorlerini yedekle
    # (brain ve code_tracker gibi klasorler cok derin yollara sahip oldugu icin hata veriyor)
    if (Test-Path "$TARGET_DIR\antigravity") { 
        $antigravityBackup = "$BACKUP_DIR\antigravity"
        New-Item -ItemType Directory -Force -Path $antigravityBackup | Out-Null

        if (Test-Path "$TARGET_DIR\antigravity\skills") {
            Write-Debug "Skills yedekleniyor..."
            Copy-Item "$TARGET_DIR\antigravity\skills" "$antigravityBackup\skills" -Recurse -Force -Confirm:$false
            Write-Success "Eski Skills yedeklendi"
        }

        if (Test-Path "$TARGET_DIR\antigravity\workflows") {
            Write-Debug "Workflows yedekleniyor..."
            Copy-Item "$TARGET_DIR\antigravity\workflows" "$antigravityBackup\workflows" -Recurse -Force -Confirm:$false
            Write-Success "Eski Workflows yedeklendi"
        }
    }

    # ============================================
    # Adim 3: Yukleme / Guncelleme
    # ============================================
    Update-Progress "Dosyalar kopyalaniyor"
    Write-Header "3. Dosyalar Yukleniyor"

    $filesCopied = 0

    # GEMINI.dist.md -> GEMINI.md
    Update-Progress "Global Kurallar yukleniyor"
    $distFile = "$SOURCE_DIR\GEMINI.dist.md"
    Write-Debug "Global kurallar kopyalaniyor: $distFile"
    if (Test-Path $distFile) {
        Copy-Item $distFile "$TARGET_DIR\GEMINI.md" -Force -Confirm:$false
        Write-Success "Global Kurallar (GEMINI.md) yuklendi"
        $filesCopied++
    }
    else {
        Write-Warning "GEMINI.dist.md bulunamadi! ($distFile)"
    }

    # KURULUM.md
    $kurulumFile = "$SOURCE_DIR\KURULUM.md"
    Write-Debug "Kurulum rehberi kopyalaniyor: $kurulumFile"
    if (Test-Path $kurulumFile) {
        Copy-Item $kurulumFile "$TARGET_DIR\KURULUM.md" -Force -Confirm:$false
        Write-Success "Kurulum Rehberi yuklendi"
        $filesCopied++
    }
    else {
        Write-Warning "KURULUM.md bulunamadi!"
    }

    # Antigravity Klasorleri
    Update-Progress "Skills ve Workflows yukleniyor"
    $antigravitySource = "$SOURCE_DIR\antigravity"
    $antigravityTarget = "$TARGET_DIR\antigravity"

    if (Test-Path $antigravitySource) {
        # Skills
        if (Test-Path "$antigravitySource\skills") {
            $skillsTarget = "$antigravityTarget\skills"
            Write-Debug "Skills guncelleniyor..."
            
            # Klasor yoksa olustur
            if (-not (Test-Path "$antigravityTarget")) { New-Item -ItemType Directory -Path "$antigravityTarget" -Force | Out-Null }
            
            # Skills temizle ve kopyala
            if (Test-Path $skillsTarget) { Remove-Item $skillsTarget -Recurse -Force -Confirm:$false }
            Copy-Item "$antigravitySource\skills" $skillsTarget -Recurse -Force -Confirm:$false
            Write-Success "Skills yuklendi"
            $filesCopied++
        }

        # Workflows
        if (Test-Path "$antigravitySource\workflows") {
            $workflowsTarget = "$antigravityTarget\workflows"
            Write-Debug "Workflows guncelleniyor..."
            
            # Klasor yoksa olustur
            if (-not (Test-Path "$antigravityTarget")) { New-Item -ItemType Directory -Path "$antigravityTarget" -Force | Out-Null }
            
            # Workflows temizle ve kopyala
            if (Test-Path $workflowsTarget) { Remove-Item $workflowsTarget -Recurse -Force -Confirm:$false }
            Copy-Item "$antigravitySource\workflows" $workflowsTarget -Recurse -Force -Confirm:$false
            Write-Success "Workflows yuklendi"
            $filesCopied++
        }
    }
    else {
        Write-Warning "antigravity kaynak klasoru bulunamadi!"
    }
    
    Update-Progress "Tamamlandi"

    # ============================================
    # Bitis
    # ============================================
    if ($filesCopied -gt 0) {
        Write-Header "ISLEM BASARILI! (v2.0.1 Yuklendi)"
        
        Write-Host "`nONEMLI HATIRLATMA:" -ForegroundColor Yellow
        Write-Host "  1. Antigravity IDE'ye git" -ForegroundColor Cyan
        Write-Host "  2. Sag ustteki uc noktaya (...) tikla" -ForegroundColor Cyan
        Write-Host "  3. 'Refresh Rules' ve 'Refresh Workflows' seceneklerine tikla" -ForegroundColor Cyan
    }
    else {
        Write-Header "UYARI: Hicbir dosya kopyalanmadi!"
    }

}
catch {
    Write-Error "KRITIK HATA OLUSTU:"
    Write-Error $_.Exception.Message
    Write-Error $_.ScriptStackTrace
}

# Pencerenin kapanmasini engelle
Write-Host "`nCikis icin ENTER tusuna basin..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

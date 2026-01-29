# ============================================
# HAVSAN Antigravity - Ekip Kurulum Scripti
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

    Clear-Host
    
    # Logo Yazdirma
    Write-Host "
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_|
                                         
      Robotik & Yapay Zeka
" -ForegroundColor Cyan

    Write-Header "HAVSAN Antigravity Kurulum Sihirbazi"

    # Dizinleri Belirleme
    $SCRIPT_DIR = $PSScriptRoot
    $PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR
    $SOURCE_DIR = "$PROJECT_ROOT\gemini"
    $TARGET_DIR = "$env:USERPROFILE\.gemini"

    Write-Info "Calisma Dizini: $PROJECT_ROOT"
    Write-Info "Kaynak Klasor:  $SOURCE_DIR"
    Write-Info "Hedef Klasor:   $TARGET_DIR"

    # ============================================
    # Adim 1: Kontroller
    # ============================================
    Write-Header "1. Ortam Kontrolu"

    if (-not (Test-Path $SOURCE_DIR)) {
        throw "Kaynak klasor bulunamadi! Beklenen: $SOURCE_DIR"
    }

    if (-not (Test-Path $TARGET_DIR)) {
        Write-Warning "Antigravity IDE klasoru bulunamadi."
        Write-Info "Klasor olusturuluyor..."
        New-Item -ItemType Directory -Force -Path $TARGET_DIR | Out-Null
    }
    else {
        Write-Success "Hedef klasor mevcut."
    }

    # ============================================
    # Adim 2: Yedekleme
    # ============================================
    Write-Header "2. Yedekleme"

    $timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $BACKUP_DIR = "$TARGET_DIR\backups\kurulum_oncesi_$timestamp"
    
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
    # Adim 3: Kurulum
    # ============================================
    Write-Header "3. Dosyalar Yukleniyor"

    $filesCopied = 0

    # GEMINI.dist.md -> GEMINI.md
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

    # ============================================
    # Bitis
    # ============================================
    if ($filesCopied -gt 0) {
        Write-Header "KURULUM BASARILI! ($filesCopied oge)"
        Write-Info "Lutfen Antigravity IDE'yi yeniden baslatin."
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

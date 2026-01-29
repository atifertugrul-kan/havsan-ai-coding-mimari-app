# ============================================
# HAVSAN Antigravity - Hizli Guncelleme
# Proje -> .gemini Klasoru Senkronizasyonu
# ============================================
# Kullanim: .\scripts\guncelle.ps1
# ============================================

# Renkli konsol ciktisi
function Write-Success { param([string]$msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Info { param([string]$msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warning { param([string]$msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Error { param([string]$msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

# ============================================
# Baslangic
# ============================================
Clear-Host
Write-Host "
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_|
                                         
      Robotik & Yapay Zeka
" -ForegroundColor Cyan

Write-Host "`n=== HAVSAN Antigravity Hizli Guncelleme ===" -ForegroundColor Magenta
Write-Host "===============================================`n" -ForegroundColor Magenta

$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
$SOURCE_DIR = "$PROJECT_ROOT\gemini"
$TARGET_DIR = "$env:USERPROFILE\.gemini"

Write-Info "Kaynak: $SOURCE_DIR"
Write-Info "Hedef: $TARGET_DIR"

# ============================================
# Kontroller
# ============================================
if (-not (Test-Path $SOURCE_DIR)) {
    Write-Error "Kaynak klasor bulunamadi: $SOURCE_DIR"
    exit 1
}

if (-not (Test-Path $TARGET_DIR)) {
    Write-Error "Antigravity klasoru bulunamadi: $TARGET_DIR"
    Write-Info "Lutfen Antigravity IDE'yi en az bir kez calistirin."
    exit 1
}

# ============================================
# Yedekleme
# ============================================
$BACKUP_DIR = "$TARGET_DIR\backups\guncelleme-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
Write-Info "`nYedekleme olusturuluyor: $BACKUP_DIR"

New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null

# Dosyalari yedekle
if (Test-Path "$TARGET_DIR\GEMINI.md") { Copy-Item "$TARGET_DIR\GEMINI.md" "$BACKUP_DIR\GEMINI.md" -Force }

# SADECE skills ve workflows'u yedekle (code_tracker hatalarini onlemek icin)
if (Test-Path "$TARGET_DIR\antigravity") {
    $antigravityBackup = "$BACKUP_DIR\antigravity"
    New-Item -ItemType Directory -Force -Path $antigravityBackup | Out-Null
    
    if (Test-Path "$TARGET_DIR\antigravity\skills") {
        Copy-Item "$TARGET_DIR\antigravity\skills" "$antigravityBackup\skills" -Recurse -Force
    }
    if (Test-Path "$TARGET_DIR\antigravity\workflows") {
        Copy-Item "$TARGET_DIR\antigravity\workflows" "$antigravityBackup\workflows" -Recurse -Force
    }
}

Write-Success "Yedekleme tamamlandi"

# ============================================
# Senkronizasyon ve Rename
# ============================================
Write-Info "`nDosyalar kopyalaniyor..."

$syncCount = 0

# 1. GEMINI.dist.md -> GEMINI.md olarak kopyala
if (Test-Path "$SOURCE_DIR\GEMINI.dist.md") {
    Copy-Item "$SOURCE_DIR\GEMINI.dist.md" "$TARGET_DIR\GEMINI.md" -Force
    Write-Success "GEMINI.md guncellendi (dist dosyasindan)"
    $syncCount++
}
elseif (Test-Path "$SOURCE_DIR\GEMINI.md") {
    # Eski yapi destegi
    Copy-Item "$SOURCE_DIR\GEMINI.md" "$TARGET_DIR\GEMINI.md" -Force
    Write-Success "GEMINI.md guncellendi"
    $syncCount++
}

# 2. KURULUM.md kopyala
if (Test-Path "$SOURCE_DIR\KURULUM.md") {
    Copy-Item "$SOURCE_DIR\KURULUM.md" "$TARGET_DIR\KURULUM.md" -Force
    Write-Success "KURULUM.md guncellendi"
    $syncCount++
}

# 3. antigravity/skills kopyala
if (Test-Path "$SOURCE_DIR\antigravity\skills") {
    $skillsTarget = "$TARGET_DIR\antigravity\skills"
    if (Test-Path $skillsTarget) { Remove-Item $skillsTarget -Recurse -Force }
    Copy-Item "$SOURCE_DIR\antigravity\skills" $skillsTarget -Recurse -Force
    Write-Success "Skills guncellendi"
    $syncCount++
}

# 4. antigravity/workflows kopyala
if (Test-Path "$SOURCE_DIR\antigravity\workflows") {
    $workflowsTarget = "$TARGET_DIR\antigravity\workflows"
    if (Test-Path $workflowsTarget) { Remove-Item $workflowsTarget -Recurse -Force }
    Copy-Item "$SOURCE_DIR\antigravity\workflows" $workflowsTarget -Recurse -Force
    Write-Success "Workflows guncellendi"
    $syncCount++
}

# ============================================
# Ozet
# ============================================
Write-Host "`n===============================================" -ForegroundColor Magenta
Write-Host "=== Guncelleme Ozeti ===" -ForegroundColor Magenta
Write-Host "===============================================" -ForegroundColor Magenta

Write-Host "`n[OK] Guncellenen: " -NoNewline -ForegroundColor Green
Write-Host "$syncCount oge"

Write-Host "[INFO] Yedek: " -NoNewline -ForegroundColor Cyan
Write-Host "$BACKUP_DIR"

Write-Success "`n[OK] Guncelleme tamamlandi!"
Write-Warning "[WARN] Antigravity IDE'yi yeniden baslatin (veya refresh edin)"

Write-Host "`n===============================================`n" -ForegroundColor Magenta

exit 0

# ============================================
# HAVSAN Antigravity - Ekip Kurulum Scripti
# ============================================
# Kullanim: .\scripts\install-team.ps1
# ============================================

# Renkli konsol ciktisi
function Write-Header { param([string]$msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta }
function Write-Success { param([string]$msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Info { param([string]$msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warning { param([string]$msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Error { param([string]$msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Clear-Host
Write-Header "HAVSAN Antigravity Kurulum Sihirbazi"

$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
$SOURCE_DIR = "$PROJECT_ROOT\gemini"
$TARGET_DIR = "$env:USERPROFILE\.gemini"

# ============================================
# Adim 1: Kontroller
# ============================================
Write-Info "1. Ortam kontrol ediliyor..."

if (-not (Test-Path $SOURCE_DIR)) {
    Write-Error "HATA: Kurulum dosyalari bulunamadi ($SOURCE_DIR)"
    exit 1
}

if (-not (Test-Path $TARGET_DIR)) {
    Write-Warning "Antigravity IDE klasoru bulunamadi."
    Write-Info "Klasor olusturuluyor..."
    New-Item -ItemType Directory -Force -Path $TARGET_DIR | Out-Null
}

Write-Success "Ortam uygun."

# ============================================
# Adim 2: Yedekleme
# ============================================
Write-Info "`n2. Mevcut ayarlar yedekleniyor..."

$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$BACKUP_DIR = "$TARGET_DIR\backups\kurulum_oncesi_$timestamp"

New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null

if (Test-Path "$TARGET_DIR\GEMINI.md") { Copy-Item "$TARGET_DIR\GEMINI.md" "$BACKUP_DIR\GEMINI.md" -Force }
if (Test-Path "$TARGET_DIR\antigravity") { Copy-Item "$TARGET_DIR\antigravity" "$BACKUP_DIR\antigravity" -Recurse -Force }

Write-Success "Yedek alindi: $BACKUP_DIR"

# ============================================
# Adim 3: Kurulum
# ============================================
Write-Info "`n3. Dosyalar yukleniyor..."

# GEMINI.md (dist dosyasindan)
if (Test-Path "$SOURCE_DIR\GEMINI.dist.md") {
    Copy-Item "$SOURCE_DIR\GEMINI.dist.md" "$TARGET_DIR\GEMINI.md" -Force
    Write-Success "Global Kurallar (GEMINI.md) yuklendi"
}

# KURULUM.md
if (Test-Path "$SOURCE_DIR\KURULUM.md") {
    Copy-Item "$SOURCE_DIR\KURULUM.md" "$TARGET_DIR\KURULUM.md" -Force
    Write-Success "Kurulum Rehberi yuklendi"
}

# Antigravity Klasorleri
$antigravitySource = "$SOURCE_DIR\antigravity"
$antigravityTarget = "$TARGET_DIR\antigravity"

if (Test-Path $antigravitySource) {
    # Skills
    if (Test-Path "$antigravitySource\skills") {
        $skillsTarget = "$antigravityTarget\skills"
        if (Test-Path $skillsTarget) { Remove-Item $skillsTarget -Recurse -Force }
        Copy-Item "$antigravitySource\skills" $skillsTarget -Recurse -Force
        Write-Success "Skills yuklendi"
    }

    # Workflows
    if (Test-Path "$antigravitySource\workflows") {
        $workflowsTarget = "$antigravityTarget\workflows"
        if (Test-Path $workflowsTarget) { Remove-Item $workflowsTarget -Recurse -Force }
        Copy-Item "$antigravitySource\workflows" $workflowsTarget -Recurse -Force
        Write-Success "Workflows yuklendi"
    }
}

# ============================================
# Bitis
# ============================================
Write-Header "Kurulum Tamamlandi!"

Write-Success "Tum dosyalar basariyla kopyalandi."
Write-Warning "Degisikliklerin aktif olmasi icin:"
Write-Info "1. Antigravity IDE'yi kapatin"
Write-Info "2. Tekrar acin"

Write-Host "`nIyi calismalar! 🚀`n" -ForegroundColor Green

# Pencerenin hemen kapanmamasi icin
Write-Host "Cikis icin bir tusa basin..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
# ============================================
# HAVSAN Antigravity Konfigürasyon Yönetimi
# Ekip Üyesi İlk Kurulum
# ============================================
# Kullanım: .\scripts\install-team.ps1
# ============================================

param(
    [switch]$Force = $false
)

# Renkli konsol çıktısı için
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$msg) Write-ColorOutput "✅ $msg" "Green" }
function Write-Info { param([string]$msg) Write-ColorOutput "ℹ️  $msg" "Cyan" }
function Write-Warning { param([string]$msg) Write-ColorOutput "⚠️  $msg" "Yellow" }
function Write-Error { param([string]$msg) Write-ColorOutput "❌ $msg" "Red" }

# ============================================
# Başlangıç
# ============================================
Write-ColorOutput "`n🚀 HAVSAN Antigravity Ekip Kurulumu" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
$ANTIGRAVITY_ROOT = "$env:USERPROFILE\.gemini"

Write-Info "Kullanıcı: $env:USERNAME"
Write-Info "Antigravity Klasörü: $ANTIGRAVITY_ROOT"

# ============================================
# 1. Antigravity Kontrolü
# ============================================
Write-Info "`n📦 Adım 1/5: Antigravity IDE kontrolü..."

if (-not (Test-Path $ANTIGRAVITY_ROOT)) {
    Write-Error "Antigravity klasörü bulunamadı: $ANTIGRAVITY_ROOT"
    Write-Info "Lütfen önce Google Antigravity IDE'yi kurun ve en az bir kez çalıştırın."
    Write-Info "İndirme: https://ide.google.com"
    exit 1
}

Write-Success "Antigravity IDE bulundu"

# ============================================
# 2. Yedekleme
# ============================================
Write-Info "`n💾 Adım 2/5: Mevcut konfigürasyonlar yedekleniyor..."

$BACKUP_DIR = "$ANTIGRAVITY_ROOT\backups\team-install-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null

$filesToBackup = @(
    "$ANTIGRAVITY_ROOT\GEMINI.md",
    "$ANTIGRAVITY_ROOT\antigravity\skills",
    "$ANTIGRAVITY_ROOT\antigravity\workflows"
)

$backupCount = 0

foreach ($file in $filesToBackup) {
    if (Test-Path $file) {
        $fileName = Split-Path $file -Leaf
        $backupPath = Join-Path $BACKUP_DIR $fileName
        Copy-Item -Path $file -Destination $backupPath -Recurse -Force -ErrorAction SilentlyContinue
        $backupCount++
    }
}

Write-Success "Yedekleme tamamlandı ($backupCount öğe)"
Write-Info "Yedek konumu: $BACKUP_DIR"

# ============================================
# 3. Konfigürasyon Doğrulama
# ============================================
Write-Info "`n🔍 Adım 3/5: Proje konfigürasyonları doğrulanıyor..."

& "$PROJECT_ROOT\scripts\validate-config.ps1"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Konfigürasyon doğrulama başarısız!"
    Write-Info "Lütfen proje yöneticisiyle iletişime geçin."
    exit 1
}

# ============================================
# 4. Senkronizasyon
# ============================================
Write-Info "`n🔄 Adım 4/5: Konfigürasyonlar Antigravity'ye kopyalanıyor..."

$syncParams = @()
if ($Force) {
    $syncParams += "-Force"
}

& "$PROJECT_ROOT\scripts\sync-to-antigravity.ps1" @syncParams

if ($LASTEXITCODE -ne 0) {
    Write-Error "Senkronizasyon başarısız!"
    Write-Info "Yedekten geri yüklemek için:"
    Write-Info "  Copy-Item -Path '$BACKUP_DIR\*' -Destination '$ANTIGRAVITY_ROOT' -Recurse -Force"
    exit 1
}

# ============================================
# 5. Final Kontroller
# ============================================
Write-Info "`n✅ Adım 5/5: Final kontrolleri..."

$finalChecks = @(
    @{
        Path = "$ANTIGRAVITY_ROOT\GEMINI.md"
        Name = "Global Rules (GEMINI.md)"
    },
    @{
        Path = "$ANTIGRAVITY_ROOT\antigravity\skills"
        Name = "Skills"
    },
    @{
        Path = "$ANTIGRAVITY_ROOT\antigravity\workflows"
        Name = "Workflows"
    }
)

$allOk = $true

foreach ($check in $finalChecks) {
    Write-Host "  🔍 " -NoNewline
    Write-Host "$($check.Name)" -ForegroundColor White -NoNewline
    
    if (Test-Path $check.Path) {
        Write-Host " - " -NoNewline
        Write-Success "OK"
    }
    else {
        Write-Host " - " -NoNewline
        Write-Error "EKSIK!"
        $allOk = $false
    }
}

# ============================================
# Özet ve Sonraki Adımlar
# ============================================
Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

if ($allOk) {
    Write-ColorOutput "🎉 Kurulum Başarıyla Tamamlandı!" "Green"
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
    
    Write-Info "`n📝 Sonraki Adımlar:"
    Write-Host "  1. " -NoNewline
    Write-Host "Antigravity IDE'yi yeniden başlatın" -ForegroundColor Yellow
    
    Write-Host "  2. " -NoNewline
    Write-Host "IDE'de 'Customizations' menüsünden Rules ve Workflows'u kontrol edin" -ForegroundColor Yellow
    
    Write-Host "  3. " -NoNewline
    Write-Host "Güncellemeleri almak için:" -ForegroundColor Yellow
    Write-Host "     git pull" -ForegroundColor Cyan
    Write-Host "     .\scripts\sync-to-antigravity.ps1" -ForegroundColor Cyan
    
    Write-Info "`n💡 İpucu: Sorun yaşarsanız yedekten geri yükleyebilirsiniz:"
    Write-Host "  Copy-Item -Path '$BACKUP_DIR\*' -Destination '$ANTIGRAVITY_ROOT' -Recurse -Force" -ForegroundColor Gray
    
    Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" "Magenta"
    
    exit 0
}
else {
    Write-ColorOutput "❌ Kurulum Başarısız!" "Red"
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
    
    Write-Error "`nBazı dosyalar eksik. Lütfen proje yöneticisiyle iletişime geçin."
    Write-Info "Yedek konumu: $BACKUP_DIR"
    
    exit 1
}

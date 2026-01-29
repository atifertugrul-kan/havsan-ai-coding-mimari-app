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
    } else {
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
} else {
    Write-ColorOutput "❌ Kurulum Başarısız!" "Red"
    Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
    
    Write-Error "`nBazı dosyalar eksik. Lütfen proje yöneticisiyle iletişime geçin."
    Write-Info "Yedek konumu: $BACKUP_DIR"
    
    exit 1
}

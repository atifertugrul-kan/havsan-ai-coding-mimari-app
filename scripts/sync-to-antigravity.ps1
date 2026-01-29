# ============================================
# HAVSAN Antigravity Konfigürasyon Yönetimi
# Senkronizasyon: Proje → Antigravity
# ============================================
# Kullanım: .\scripts\sync-to-antigravity.ps1
# ============================================

param(
    [switch]$DryRun = $false,
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
# Konfigürasyon
# ============================================
$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
$ANTIGRAVITY_ROOT = "$env:USERPROFILE\.gemini"

$SYNC_MAPPINGS = @(
    @{
        Source = "$PROJECT_ROOT\config\GEMINI.md"
        Target = "$ANTIGRAVITY_ROOT\GEMINI.md"
        Type = "File"
    },
    @{
        Source = "$PROJECT_ROOT\skills"
        Target = "$ANTIGRAVITY_ROOT\antigravity\skills"
        Type = "Directory"
    },
    @{
        Source = "$PROJECT_ROOT\workflows"
        Target = "$ANTIGRAVITY_ROOT\antigravity\workflows"
        Type = "Directory"
    }
)

# ============================================
# Başlangıç
# ============================================
Write-ColorOutput "`n🚀 HAVSAN Antigravity Senkronizasyon Başlatılıyor..." "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

if ($DryRun) {
    Write-Warning "DRY RUN MODE - Hiçbir dosya değiştirilmeyecek"
}

# ============================================
# Antigravity Klasör Kontrolü
# ============================================
Write-Info "Antigravity klasörü kontrol ediliyor: $ANTIGRAVITY_ROOT"

if (-not (Test-Path $ANTIGRAVITY_ROOT)) {
    Write-Error "Antigravity klasörü bulunamadı: $ANTIGRAVITY_ROOT"
    Write-Info "Lütfen Google Antigravity IDE'nin kurulu olduğundan emin olun."
    exit 1
}

Write-Success "Antigravity klasörü bulundu"

# ============================================
# Yedekleme
# ============================================
if (-not $DryRun -and -not $Force) {
    $BACKUP_DIR = "$ANTIGRAVITY_ROOT\backups\$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
    Write-Info "Mevcut dosyalar yedekleniyor: $BACKUP_DIR"
    
    New-Item -ItemType Directory -Force -Path $BACKUP_DIR | Out-Null
    
    foreach ($mapping in $SYNC_MAPPINGS) {
        if (Test-Path $mapping.Target) {
            $backupPath = Join-Path $BACKUP_DIR (Split-Path $mapping.Target -Leaf)
            Copy-Item -Path $mapping.Target -Destination $backupPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Success "Yedekleme tamamlandı"
}

# ============================================
# Senkronizasyon
# ============================================
Write-Info "`nDosyalar senkronize ediliyor..."

$syncCount = 0
$errorCount = 0

foreach ($mapping in $SYNC_MAPPINGS) {
    $sourcePath = $mapping.Source
    $targetPath = $mapping.Target
    $type = $mapping.Type
    
    Write-Host "`n📂 " -NoNewline
    Write-Host "$(Split-Path $sourcePath -Leaf)" -ForegroundColor White -NoNewline
    Write-Host " → " -NoNewline
    Write-Host "$targetPath" -ForegroundColor Gray
    
    # Kaynak dosya kontrolü
    if (-not (Test-Path $sourcePath)) {
        Write-Warning "Kaynak bulunamadı, atlanıyor: $sourcePath"
        continue
    }
    
    if ($DryRun) {
        Write-Info "[DRY RUN] Kopyalanacak: $sourcePath → $targetPath"
        $syncCount++
        continue
    }
    
    try {
        # Hedef klasörü oluştur
        $targetDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }
        
        # Kopyalama
        if ($type -eq "File") {
            Copy-Item -Path $sourcePath -Destination $targetPath -Force
        } else {
            # Klasör için: önce hedefi temizle, sonra kopyala
            if (Test-Path $targetPath) {
                Remove-Item -Path $targetPath -Recurse -Force
            }
            Copy-Item -Path $sourcePath -Destination $targetPath -Recurse -Force
        }
        
        Write-Success "Kopyalandı"
        $syncCount++
        
    } catch {
        Write-Error "Hata: $_"
        $errorCount++
    }
}

# ============================================
# Özet
# ============================================
Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
Write-ColorOutput "📊 Senkronizasyon Özeti" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

Write-Host "✅ Başarılı: " -NoNewline -ForegroundColor Green
Write-Host "$syncCount dosya/klasör"

if ($errorCount -gt 0) {
    Write-Host "❌ Hatalı: " -NoNewline -ForegroundColor Red
    Write-Host "$errorCount dosya/klasör"
}

if ($DryRun) {
    Write-Warning "`nDRY RUN tamamlandı. Gerçek senkronizasyon için -DryRun parametresini kaldırın."
} else {
    Write-Success "`n🎉 Senkronizasyon başarıyla tamamlandı!"
    Write-Info "Antigravity IDE'yi yeniden başlatmanız önerilir."
}

Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" "Magenta"

exit $errorCount

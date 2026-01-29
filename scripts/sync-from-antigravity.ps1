# ============================================
# HAVSAN Antigravity Konfigürasyon Yönetimi
# Senkronizasyon: Antigravity → Proje
# ============================================
# Kullanım: .\scripts\sync-from-antigravity.ps1
# ============================================

param(
    [switch]$DryRun = $false,
    [switch]$AutoCommit = $false
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
        Source = "$ANTIGRAVITY_ROOT\GEMINI.md"
        Target = "$PROJECT_ROOT\config\GEMINI.md"
        Type = "File"
    },
    @{
        Source = "$ANTIGRAVITY_ROOT\antigravity\skills"
        Target = "$PROJECT_ROOT\skills"
        Type = "Directory"
    },
    @{
        Source = "$ANTIGRAVITY_ROOT\antigravity\workflows"
        Target = "$PROJECT_ROOT\workflows"
        Type = "Directory"
    }
)

# ============================================
# Başlangıç
# ============================================
Write-ColorOutput "`n🔄 HAVSAN Antigravity → Proje Senkronizasyonu" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

if ($DryRun) {
    Write-Warning "DRY RUN MODE - Hiçbir dosya değiştirilmeyecek"
}

# ============================================
# Git Durumu Kontrolü
# ============================================
Write-Info "Git durumu kontrol ediliyor..."

Push-Location $PROJECT_ROOT

$gitStatus = git status --porcelain 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Warning "Git repository bulunamadı. Devam ediliyor..."
} elseif ($gitStatus) {
    Write-Warning "Çalışma dizininde commit edilmemiş değişiklikler var:"
    Write-Host $gitStatus -ForegroundColor Yellow
    Write-Info "Devam etmek için Enter'a basın, iptal için Ctrl+C..."
    if (-not $DryRun) {
        Read-Host
    }
}

Pop-Location

# ============================================
# Değişiklik Tespiti
# ============================================
Write-Info "`nDeğişiklikler tespit ediliyor..."

$changedFiles = @()

foreach ($mapping in $SYNC_MAPPINGS) {
    $sourcePath = $mapping.Source
    $targetPath = $mapping.Target
    
    if (-not (Test-Path $sourcePath)) {
        Write-Warning "Kaynak bulunamadı: $sourcePath"
        continue
    }
    
    if (-not (Test-Path $targetPath)) {
        $changedFiles += $mapping
        Write-Info "Yeni: $(Split-Path $sourcePath -Leaf)"
        continue
    }
    
    # Dosya karşılaştırması (basit: boyut ve değişiklik tarihi)
    if ($mapping.Type -eq "File") {
        $sourceHash = Get-FileHash $sourcePath -Algorithm MD5
        $targetHash = Get-FileHash $targetPath -Algorithm MD5
        
        if ($sourceHash.Hash -ne $targetHash.Hash) {
            $changedFiles += $mapping
            Write-Info "Değişti: $(Split-Path $sourcePath -Leaf)"
        }
    } else {
        # Klasör için: her zaman kopyala (detaylı karşılaştırma pahalı)
        $changedFiles += $mapping
        Write-Info "Klasör: $(Split-Path $sourcePath -Leaf)"
    }
}

if ($changedFiles.Count -eq 0) {
    Write-Success "`n✨ Hiçbir değişiklik yok. Her şey güncel!"
    exit 0
}

Write-Info "`n$($changedFiles.Count) öğe senkronize edilecek"

# ============================================
# Senkronizasyon
# ============================================
if (-not $DryRun) {
    Write-Info "`nDosyalar kopyalanıyor..."
}

$syncCount = 0

foreach ($mapping in $changedFiles) {
    $sourcePath = $mapping.Source
    $targetPath = $mapping.Target
    $type = $mapping.Type
    
    Write-Host "`n📂 " -NoNewline
    Write-Host "$(Split-Path $sourcePath -Leaf)" -ForegroundColor White -NoNewline
    Write-Host " → " -NoNewline
    Write-Host "$targetPath" -ForegroundColor Gray
    
    if ($DryRun) {
        Write-Info "[DRY RUN] Kopyalanacak"
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
    }
}

# ============================================
# Git Commit (Opsiyonel)
# ============================================
if (-not $DryRun -and $AutoCommit -and $syncCount -gt 0) {
    Write-Info "`nGit commit oluşturuluyor..."
    
    Push-Location $PROJECT_ROOT
    
    git add config/ skills/ workflows/
    
    $commitMessage = "chore: Sync Antigravity configs from IDE`n`nUpdated $syncCount item(s) from Antigravity IDE"
    
    git commit -m $commitMessage
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Git commit oluşturuldu"
        Write-Info "Push için: git push"
    }
    
    Pop-Location
}

# ============================================
# Özet
# ============================================
Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
Write-ColorOutput "📊 Senkronizasyon Özeti" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

Write-Host "✅ Senkronize edildi: " -NoNewline -ForegroundColor Green
Write-Host "$syncCount öğe"

if ($DryRun) {
    Write-Warning "`nDRY RUN tamamlandı. Gerçek senkronizasyon için -DryRun parametresini kaldırın."
} else {
    Write-Success "`n🎉 Senkronizasyon başarıyla tamamlandı!"
    
    if (-not $AutoCommit) {
        Write-Info "Git commit için: .\scripts\sync-from-antigravity.ps1 -AutoCommit"
    }
}

Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" "Magenta"

exit 0

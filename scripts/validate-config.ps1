# ============================================
# HAVSAN Antigravity Konfigürasyon Yönetimi
# Konfigürasyon Doğrulama
# ============================================
# Kullanım: .\scripts\validate-config.ps1
# ============================================

param(
    [switch]$Verbose = $false
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
Write-ColorOutput "`n🔍 HAVSAN Antigravity Konfigürasyon Doğrulama" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

$PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
$errorCount = 0
$warningCount = 0
$checkCount = 0

# ============================================
# 1. GEMINI.md Kontrolü
# ============================================
Write-Info "`n📄 GEMINI.md kontrol ediliyor..."
$checkCount++

$geminiPath = "$PROJECT_ROOT\config\GEMINI.md"

if (-not (Test-Path $geminiPath)) {
    Write-Error "GEMINI.md bulunamadı: $geminiPath"
    $errorCount++
} else {
    $content = Get-Content $geminiPath -Raw
    
    # Başlık kontrolü
    if ($content -match "^# .*HAVSAN.*RULES") {
        Write-Success "Başlık formatı doğru"
    } else {
        Write-Warning "Başlık formatı beklenen formatta değil"
        $warningCount++
    }
    
    # Zorunlu bölümler
    $requiredSections = @(
        "DİL VE İLETİŞİM",
        "DOCKER-FIRST",
        "FRONTEND-FIRST",
        "TEKNOLOJİ TERCİHLERİ"
    )
    
    foreach ($section in $requiredSections) {
        if ($content -match $section) {
            if ($Verbose) { Write-Success "Bölüm bulundu: $section" }
        } else {
            Write-Warning "Eksik bölüm: $section"
            $warningCount++
        }
    }
    
    Write-Success "GEMINI.md doğrulandı"
}

# ============================================
# 2. Skills Kontrolü
# ============================================
Write-Info "`n🎯 Skills kontrol ediliyor..."
$checkCount++

$skillsPath = "$PROJECT_ROOT\skills"

if (-not (Test-Path $skillsPath)) {
    Write-Error "Skills klasörü bulunamadı: $skillsPath"
    $errorCount++
} else {
    $skillDirs = Get-ChildItem -Path $skillsPath -Directory
    
    if ($skillDirs.Count -eq 0) {
        Write-Warning "Hiçbir skill bulunamadı"
        $warningCount++
    } else {
        Write-Info "$($skillDirs.Count) skill bulundu"
        
        foreach ($skillDir in $skillDirs) {
            $skillMdPath = Join-Path $skillDir.FullName "SKILL.md"
            
            Write-Host "  📦 " -NoNewline
            Write-Host "$($skillDir.Name)" -ForegroundColor White -NoNewline
            
            if (-not (Test-Path $skillMdPath)) {
                Write-Host " - " -NoNewline
                Write-Error "SKILL.md eksik!"
                $errorCount++
                continue
            }
            
            # YAML frontmatter kontrolü
            $skillContent = Get-Content $skillMdPath -Raw
            
            if ($skillContent -match "^---\s*\n") {
                # Frontmatter var
                if ($skillContent -match "description:\s*.+") {
                    Write-Host " - " -NoNewline
                    Write-Success "OK"
                } else {
                    Write-Host " - " -NoNewline
                    Write-Warning "description eksik"
                    $warningCount++
                }
            } else {
                Write-Host " - " -NoNewline
                Write-Warning "YAML frontmatter eksik"
                $warningCount++
            }
        }
    }
}

# ============================================
# 3. Workflows Kontrolü
# ============================================
Write-Info "`n⚙️  Workflows kontrol ediliyor..."
$checkCount++

$workflowsPath = "$PROJECT_ROOT\workflows"

if (-not (Test-Path $workflowsPath)) {
    Write-Error "Workflows klasörü bulunamadı: $workflowsPath"
    $errorCount++
} else {
    $workflowFiles = Get-ChildItem -Path $workflowsPath -Filter "*.md"
    
    if ($workflowFiles.Count -eq 0) {
        Write-Warning "Hiçbir workflow bulunamadı"
        $warningCount++
    } else {
        Write-Info "$($workflowFiles.Count) workflow bulundu"
        
        foreach ($workflowFile in $workflowFiles) {
            Write-Host "  🔧 " -NoNewline
            Write-Host "$($workflowFile.Name)" -ForegroundColor White -NoNewline
            
            $workflowContent = Get-Content $workflowFile.FullName -Raw
            
            # YAML frontmatter kontrolü
            if ($workflowContent -match "^---\s*\n") {
                if ($workflowContent -match "description:\s*.+") {
                    Write-Host " - " -NoNewline
                    Write-Success "OK"
                } else {
                    Write-Host " - " -NoNewline
                    Write-Warning "description eksik"
                    $warningCount++
                }
            } else {
                Write-Host " - " -NoNewline
                Write-Warning "YAML frontmatter eksik"
                $warningCount++
            }
        }
    }
}

# ============================================
# 4. Dosya Bütünlüğü Kontrolü
# ============================================
Write-Info "`n🔐 Dosya bütünlüğü kontrol ediliyor..."
$checkCount++

$criticalFiles = @(
    "$PROJECT_ROOT\config\GEMINI.md",
    "$PROJECT_ROOT\.gitignore",
    "$PROJECT_ROOT\scripts\sync-to-antigravity.ps1",
    "$PROJECT_ROOT\scripts\sync-from-antigravity.ps1"
)

$missingFiles = @()

foreach ($file in $criticalFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Error "Eksik kritik dosyalar:"
    foreach ($file in $missingFiles) {
        Write-Host "  ❌ $file" -ForegroundColor Red
    }
    $errorCount += $missingFiles.Count
} else {
    Write-Success "Tüm kritik dosyalar mevcut"
}

# ============================================
# Özet
# ============================================
Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"
Write-ColorOutput "📊 Doğrulama Özeti" "Magenta"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

Write-Host "🔍 Toplam Kontrol: " -NoNewline
Write-Host "$checkCount"

Write-Host "✅ Başarılı: " -NoNewline -ForegroundColor Green
Write-Host "$($checkCount - $errorCount - $warningCount)"

if ($warningCount -gt 0) {
    Write-Host "⚠️  Uyarı: " -NoNewline -ForegroundColor Yellow
    Write-Host "$warningCount"
}

if ($errorCount -gt 0) {
    Write-Host "❌ Hata: " -NoNewline -ForegroundColor Red
    Write-Host "$errorCount"
}

Write-ColorOutput "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Magenta"

if ($errorCount -eq 0) {
    Write-Success "🎉 Tüm doğrulamalar başarılı!`n"
    exit 0
} else {
    Write-Error "❌ Doğrulama başarısız. Lütfen hataları düzeltin.`n"
    exit 1
}

# HAVSAN Version Synchronization Policy

**Kural:** `antigravity-kurulum.ps1` scripti güncellendiğinde, aşağıdaki dosyaların versiyon numaraları **ZORUNLU** olarak güncellenmelidir.

**Senkronize Edilecek Dosyalar:**
1.  `scripts/antigravity-kurulum.ps1` (Header, $CHANGELOG, Success Message)
2.  `README.md` (Badge/Title)
3.  `gemini/GEMINI.dist.md` (Title)
4.  `gemini/antigravity/workflows/*.md` (YAML 'description' field)

**Neden?**
- IDE'de (Cursor/VSCode) Görünen Kurallar ve Workflow listesi bu dosyalardan beslenir.
- Script versiyonu ile Dokümantasyon versiyonu uyumsuz olursa kullanıcı yanılır.

**Prosedür:**
- Powershell dosyasında version bump yaptığın (örneğin v2.5.0 -> v2.5.1) SANIYEDE, diğer 3 dosyayı da aç ve aynı numarayı yaz.
- Commit mesajında "Universal Version Sync (vX.X.X)" ibaresini kullan.

class Sbomdelta < Formula
  desc "Explains why vulnerability counts differ between upstream and hardened images"
  homepage "https://github.com/interlynk-io/sbomdelta"
  url "https://github.com/interlynk-io/sbomdelta/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "e164d91a50aa39cdfcd3358326758b67efbd1beb735df6efa9ead2d97d4a6c06"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/sbomdelta.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3191f899a7f8d293a55ae5b19e9d99f23d7b7b5ab5464fdbfd9ba20aedb534d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3191f899a7f8d293a55ae5b19e9d99f23d7b7b5ab5464fdbfd9ba20aedb534d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6fb67e474200b5373efbde3b705be8ed60a0948b55148a9350a39053d8edc83"
    sha256 cellar: :any,                 x86_64_linux:  "20a7e2187fd77b287383dfc89f774ab0558742a2914c811e80fef74566ecc6df"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable bin/"sbomdelta", shell_parameter_format: :cobra
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    { "upstream" => "7.80.0", "hardened" => "7.88.0" }.each do |image, curl|
      (testpath/"#{image}.cdx.json").write <<~JSON
        {
          "bomFormat": "CycloneDX", "specVersion": "1.4", "components": [
            { "type": "library", "name": "curl", "version": "#{curl}" },
            { "type": "library", "name": "zlib", "version": "1.2.11" }
          ]
        }
      JSON
      (testpath/"#{image}.trivy.json").write <<~JSON
        {
          "Results": [
            {
              "Vulnerabilities": [
                { "PkgName": "curl", "InstalledVersion": "#{curl}", "VulnerabilityID": "CVE-2024-2222", "Severity": "HIGH" },
                { "PkgName": "zlib", "InstalledVersion": "1.2.11", "VulnerabilityID": "CVE-2024-3333", "Severity": "LOW" }
              ]
            }
          ]
        }
      JSON
    end

    output = shell_output("#{bin}/sbomdelta eval " \
                          "--up-sbom=upstream.cdx.json --hd-sbom=hardened.cdx.json " \
                          "--up-vuln=upstream.trivy.json --hd-vuln=hardened.trivy.json")
    assert_match "CVEs removed because packages disappeared", output
    assert_match "CVEs added because packages appeared", output
    assert_match(/zlib@1\.2\.11\s+CVE-2024-3333\s+BOTH_SAME_SEVERITY\s+LOW\s+LOW/, output)
  end
end

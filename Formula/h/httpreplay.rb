class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "00e7a8bcfb0c4216e269bb1521713ce0bf48a8a36067c3782fd591e8e31ddace"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35824513d4001a6b538830f8e11f1fa6c1a2a722ad92545c976a7ef947816087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35824513d4001a6b538830f8e11f1fa6c1a2a722ad92545c976a7ef947816087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9892f48d486f27d08673e795069486f7fd0b84046755e460ca29c87fc308a11"
    sha256 cellar: :any,                 x86_64_linux:  "6c73b02a38ea78d1e51c07f2efcfd5a6d5356a3137a3779063817ba2836a674e"
  end
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"httpreplay")
  end

  test do
    (testpath/"requests.txt").write <<~EOS
      https://example.com/api/status
      https://example.com/api/post -X POST -H "Content-Type: application/json" -d '{"key":"value"}'
    EOS

    output = shell_output("#{bin}/httpreplay requests.txt -d -q 1 -c 1 2>&1")
    assert_match "<dry-run> http request: method=\"GET\" url=\"https://example.com/api/status\"", output
    assert_match "final progress: tapePosition=2", output
    assert_path_exists testpath/"requests.txt.httpreplay-pos.dry-run"
  end
end

class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "00e7a8bcfb0c4216e269bb1521713ce0bf48a8a36067c3782fd591e8e31ddace"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2cc47904babb09efe92434c3ae3a22613dfef2de60856f9b32ef67df53bc77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2cc47904babb09efe92434c3ae3a22613dfef2de60856f9b32ef67df53bc77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ca7738b859eb9cd6c91f31ccf719f6853d2fc9aa830b30bfdc376176f5867a"
    sha256 cellar: :any,                 x86_64_linux:  "1c6b2299f255bbac3c30322dc3c458e7a450432458f3b15b4383ab29265921c1"
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

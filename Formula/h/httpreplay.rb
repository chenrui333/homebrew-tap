class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "36059e60dabef44f3bb896c192646602ea15f2c923cbe5cdcaac898da0bfc527"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f366196e85ecc77c59dde546b2f4240174ae720087cce21bfa58193025d28e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f366196e85ecc77c59dde546b2f4240174ae720087cce21bfa58193025d28e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5bfd62cf204b6c43ce7116b8658775c0a28347cf80502cd0f9bf8f92bf2d6e6"
    sha256 cellar: :any,                 x86_64_linux:  "6de61b471a48f66d4abd7a6603ae84577be6f18ecd15f31cfec468a86195634a"
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

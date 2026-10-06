class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e28d6eaa2f56f07f3ca60c41cf783316fd0c9f1bf9778cc99c8230170c01d999"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816a4bd977d109d99ba93fc1fe2f3fdc74dc7eabb41dcde757f6a95f1cb0a6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "816a4bd977d109d99ba93fc1fe2f3fdc74dc7eabb41dcde757f6a95f1cb0a6c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50723f1ae3e714d702618e1d633591bb754b5e53aaef26373eb1f4ae233d074"
    sha256 cellar: :any,                 x86_64_linux:  "7714ddfd2cf73a758cf97c999217de49e18cc1d49774e66d1426d27847567af9"
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

class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "7fa02e5384b72fc285fa4ab35c47e003f0149397b3d9ec2951b1ccc24f3e7541"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a58bb49d570f042e12d0e760cfa94bd59950ab0fc6172af50a3e2b6225d19853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58bb49d570f042e12d0e760cfa94bd59950ab0fc6172af50a3e2b6225d19853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e64f209572b996caa4ec9f583f458b0dede7a922baead4bed306326e3c4a1d"
    sha256 cellar: :any,                 x86_64_linux:  "5b3b13528a171b9b064dbc9c6a1ad260a4eb3852beb6f818e86aae5ecce685b2"
  end
  depends_on "go" => :build

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

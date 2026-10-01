class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "4075f22c281adb7d6fcfd544fd226f98f8be9519e556531a4441ffe13ff68543"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88330a37267751485f4dc9fdb95a7d9818578db9f3825ee714dd455cd0b25a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88330a37267751485f4dc9fdb95a7d9818578db9f3825ee714dd455cd0b25a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3f8ad62e0c0366d7ce43908b1811d9d8cf3193a4c4716504dd0f1504ad4e80b"
    sha256 cellar: :any,                 x86_64_linux:  "c5ec4afe3c1e0f639441e4bb5d83bab5857ee2285df1d3fe4a86e4088d78b2f2"
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

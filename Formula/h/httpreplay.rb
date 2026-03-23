class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "6630a42cd3d30465970bedb5b4501ea7f60b30df36791eb72d84f1dedafe3b71"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2963065ccc8dc88f63bed0c96d92df4fe50f85d19799b0425f0801ad5871d2e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2963065ccc8dc88f63bed0c96d92df4fe50f85d19799b0425f0801ad5871d2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2963065ccc8dc88f63bed0c96d92df4fe50f85d19799b0425f0801ad5871d2e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "277167907278e510583356c253745c5054e4e65f176476dce3060de831911ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295d7e3a6b9522791e8e297a4aeaa6f9448c5bb5c6fb48a354aae5319464b2a4"
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

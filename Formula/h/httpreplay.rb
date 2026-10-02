class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "63ea50d6159a3a9dd71e93a354fea0cc7a7987d04d349ca665638e0b69bf7b44"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8466a7a3d49709ac17f38a278989892072d68e06669cd0be8af44e14e60d1c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8466a7a3d49709ac17f38a278989892072d68e06669cd0be8af44e14e60d1c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "366adecbac5802e72acc5a834e8f59bb4b2c3712aeaa6f189f82ad9a364a45e4"
    sha256 cellar: :any,                 x86_64_linux:  "a0ed9f6ef14759c1a7e33e513d92910b6d1b9ced0f92ad397d4bb4f6b223117c"
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

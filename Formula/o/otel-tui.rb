class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "fc8a5ab4416b9428532978cb759b31f83bc27e8617e44545c53fb41d401a3d91"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e5eb60f1b9a5683cfc90c1402ad4ae66f2060d99cf14123593af1827fd72eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4858285c92772d219b3b434566f935d1bed6d43661e8bf480ce5b145e402ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d51bcb8ebf407426eb9e292177bd4d13ea74b2d6b110ae9898a0388974d903"
    sha256 cellar: :any,                 x86_64_linux:  "aa2c422dbd072283f0d08ec9eac745e07c25d0e6e0b8cd403c373f39c35a1275"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    ENV["GOWORK"] = "off"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otel-tui --version")

    output = shell_output("#{bin}/otel-tui --invalid-flag 2>&1", 1)
    assert_match "unknown flag: --invalid-flag", output
  end
end

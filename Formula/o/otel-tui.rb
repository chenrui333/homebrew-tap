class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "fc8a5ab4416b9428532978cb759b31f83bc27e8617e44545c53fb41d401a3d91"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86bc452136b9eb6e9d8b6fb17ccbf4844b2af84e28041993610159bd883b0129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "402e8f5b36e23e27c5dfd67f1f6e81aaa77e5e2145875ec3ee95ce16af1375d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c9c7275b18b4689f4a54e21d5f9cef808cca1d326e119cf1422f9516c13009"
    sha256 cellar: :any,                 x86_64_linux:  "ecf887370c0eb300863cac0959d6c3f54b6b1446f94ec5bfe9fa6f5968435fd7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    ENV["GOWORK"] = "off"
    system "go", "mod", "download"
  end

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

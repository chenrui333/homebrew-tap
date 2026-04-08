class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "d6b270a4d0943047218eb008803bd2add106f95884facf9b64716e293154035f"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

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
  end
end

class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "d6b270a4d0943047218eb008803bd2add106f95884facf9b64716e293154035f"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f4a79bce75544466651e0bf3cf75ca18f4780c33fa61975cf91f1d19eeb62b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdccd8573fc67e69e5e504f05e9d66fcd831ec1c0a2c5a39c7736a01f1057d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc3bc76cebc428dbd3d65a2162e4c7da89e25c49caf2d284aa81ea0439e5b7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e42e8979432c8974886511e0777bdd4ff15360128966d65c0f3b5caab86bda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d311a9ab6e4ed9fb6ba119141f41c0e0adf9ea838b6f48245d324e6ead185d0d"
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
  end
end

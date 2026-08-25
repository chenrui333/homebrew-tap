class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.32.tar.gz"
  sha256 "6c8052fbcb5c23e16bbd8f635b36184b46732cc0edc4b70ae2aeed62fca34b96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "540c63a2305d9ad1105ca6a7954f7e9dfbe592ff4cae5704da1449cd17f5812a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129655ce9fd424a1b8fc43d000bceb1bebe4328568e8fbc691915d903647505f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0669d4e70718c87902831d6b948d3d3c2cbe566d2a94a27e750925bf1f7f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f326bb714f3b6a93ceeefdeaf238a0e37c9a16e30b7bbe93dbaa32b307b7ddf7"
    sha256 cellar: :any,                 x86_64_linux:  "db772f6e33c08cbacd0c34745e91f24bc4064f5308d57d5313406d9f78d7f961"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end

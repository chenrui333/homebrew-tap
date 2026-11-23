class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.127.tar.gz"
  sha256 "82b5e18cc8f0cee7b675b682015917accf551588fe17b9742152d97eea4d3f1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "17581c307ffd6e52ffd6cb85dc0a7071523d56682e47bff9bdbbbd1df50a377d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f2c9c9edd76616a9ce2e2363cb560f5e21141f86aaf7744c7952d2c252a82b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09712265edf8626998ae10ce70de83db81deb6ff85ee25b4451496a79012010a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd15851ad1101169a90e0c874e68e691c814cabba9c2f5f53759cf117eca60f"
    sha256 cellar: :any,                 x86_64_linux:  "a626f480b5faad443c950168be6b728e0f642b0b79b6c1ea1e3ca9c862a7161e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

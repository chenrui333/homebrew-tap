class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.118.tar.gz"
  sha256 "36fb8bf8e0b31d5efc2e3ff65e96e8a5b9502d31f764bd86d74119aa9bc24c1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fbc6c3a3004e889a305b0df6b18a9de11ed33d7050e76c799e68753c9ec7edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350863c564be3d7220e899f40cd81b70db44d85d563119a87e3369aba948c036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881f66f7530eb5da6ae92d2625ac4919bdb388524fdca836ab0a106d5514f9a8"
    sha256 cellar: :any,                 x86_64_linux:  "699f70bb069f469b3096ac15e92c3df4ae5e48f49432aafba093975022f41e71"
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

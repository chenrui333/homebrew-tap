class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.95.tar.gz"
  sha256 "6b9fe2701c7ee8cce2cd146df15f942f35ae2c888ced83141ed620a6c74d76eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6afeaceaf542ff675991620038a7f08c940adfb5ed5ec697c38a59ba7468fd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60628c7f41e2432655976e2461c84e78dc5a9922340df08ee038d90f0954b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de7392894dd11e693c86075f452777d2c5be0d82e4cd8622e376f21cfbce4542"
    sha256 cellar: :any,                 x86_64_linux:  "c475e971b17d6051057ace764c862599cae098af816f98aae09f0a38870a0fa5"
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

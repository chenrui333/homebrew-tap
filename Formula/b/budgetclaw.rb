class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.32.tar.gz"
  sha256 "6c8052fbcb5c23e16bbd8f635b36184b46732cc0edc4b70ae2aeed62fca34b96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6cd58c27f76035e457969eb17af830453cb7b80d9aede0e6821bc7b259e7705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a559e502eab3b95283ccb3ed404f51b9707d2a00f9f5e6db8ff121d4b2d774be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f26ff160aba9348c6915152d36f3f5ae0d039ae7bdab6e2852c39b11ae5834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f821eec52c78ae4f100a442917e896dcdc2c1da1041fefb3d6d1c7d73be94b9d"
    sha256 cellar: :any,                 x86_64_linux:  "eab73bcd691535e88fe24058f526d3af897beed49b2fd9f808dd860aa6f1a3b8"
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

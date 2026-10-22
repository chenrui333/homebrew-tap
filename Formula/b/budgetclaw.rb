class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.90.tar.gz"
  sha256 "3476f8792b9d3056d2da1f15fc8112679e7ec3a8ccc5326eff0154542ee24d1a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46bd7c6e92aaa2cd4cac6947ffc571fc01f9831c6c5f69612458420ffd0b6fea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd88ea61de2bd49b02d6708fc8f8f308dc220a1424525de21552ccdc3fc99014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "796e470b0bc9acf7ba06c26bed3fd4515e1475c5340d140821507879745724a1"
    sha256 cellar: :any,                 x86_64_linux:  "abb1bdf8b2e693801ba479acb33f7fb7ded0531583f46f12cf2e201139bb0583"
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

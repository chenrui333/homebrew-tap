class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.41.tar.gz"
  sha256 "c01ae5d17dd33e5a3b5e07c77ba2fb61c4ded2dd39bf75650f1664ef462c93e5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9c953f3ce797a44dda9a76afcf105540854a38e15d58309912e1935a90bf84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538bc97bd9c137af692c6a6c250599a7be934935c7d9a2c4cffe91c28a0da127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e5bca2136998f26b82ca07be1da1b29cdd8a9b664cca45f9244910718c4679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63ec4bd0ac73c19609612470f6bdec527fca99942187304d6613fead4ffc77f"
    sha256 cellar: :any,                 x86_64_linux:  "45c1f9ac542c0622c7d789225158d3916ff6a2be792c9c1b535d22004f3a66ee"
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

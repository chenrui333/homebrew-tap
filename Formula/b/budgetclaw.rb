class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "4fe6661a4f64027e2383d0bd4a3a87ee623e6ded695a5afd4deb5b66d0b7a60a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc9ca600426942ed8ea91a9bebe0430a7dd0f831f15bfc70b1dee47a80d24652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d437495c946518a672fa2c420d0c041f641fb3b9c391398c479a149614507e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aee759984b9b6b2a1ca195d72eba3a429996351c720899fb932c4797097a6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3925f07f72e9873eee19da68171f57809a106369bc2da1dedbd1d2ede8f111bd"
    sha256 cellar: :any,                 x86_64_linux:  "afac7e1078978a8290f20e906998dfca31d06f93c70e3de83eb987107d1e2d10"
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

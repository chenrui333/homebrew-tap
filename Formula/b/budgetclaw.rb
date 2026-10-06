class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.82.tar.gz"
  sha256 "4727fbb569d258052586b383066e7a477d97da76a8a246da9cd04ee9acb79bd9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a936383dcaeb9c92a5064c94234cd974053f7765903f918cdd34bc0fed42aaf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b1a482ab29e6886ca624ae5db5df284e57fb3bd60b7b5bf9097e671fe11fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "750e436714ce3bf42e71ee5917b294f9858ffa63049e1471e6ae177e13ece352"
    sha256 cellar: :any,                 x86_64_linux:  "df17efd6a9ad99b0bb1cb6e11af6049d820146e1dd1e85720b21c037bc64f63e"
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

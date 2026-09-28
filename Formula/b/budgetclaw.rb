class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.73.tar.gz"
  sha256 "b0405ac27e123b8867406b58cad02272753a6f2ed8942b709fdaa48aa3513e99"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b5af605bc9a457e7ae67692dec4eb57c26440e11a6b0f739c5d1ca8dc15bea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19187027d21773566137f55cd3425591e5f87391668f07a430a829acfaaf4b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "816eaae98806bb303895951024cc74313a3b525b27e7e4334d1dc6657ffeb41c"
    sha256 cellar: :any,                 x86_64_linux:  "f15e30e1521434e0e436b4ea6451a66376bb3f17d974ca5aea9f514943535583"
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

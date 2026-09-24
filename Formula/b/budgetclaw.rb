class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.67.tar.gz"
  sha256 "da194d61efb4f37e1dfd9453fc228e1fd2d289f3cc522e8a7178ac81d8484e9e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5bfed8427ee420a9b3db3092e3e61e59748b901afa1be36669324b0ee59d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65fc884d01d74e26b57ac7c40fc49b4964b8b9d4fee41ab532e5d15e2ee05d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3b71c3ffd7ed86829caae626be553a52f0ae34bc7bf2618946fc5f690aeb36"
    sha256 cellar: :any,                 x86_64_linux:  "1e700ca3170df66cbe901deb773ac8a41c1f5951271ce87355523c22a443edf9"
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

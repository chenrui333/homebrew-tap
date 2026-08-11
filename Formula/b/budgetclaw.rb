class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.15.tar.gz"
  sha256 "7db692401db11d984996bf820d9bcf25a9a25b2d628f139e492d89aa7d139fe7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a67d3d7674bbef6914992339875751d4ac0c5ab281c4e75e700cedbdd582a76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849b920485ea5e87652579f879ba82b38b1017d3f81b678924caa3f3cfcc39fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db2dcd89f627d8b1b1b4b125131d116a2135a3a3f762b1841413f57cebae0dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4dc9fce531dba5faee6584d97cce82b4b4c1aafae26b5f9274315a7899c763e"
    sha256 cellar: :any,                 x86_64_linux:  "3994a2a37a7582abb169433c7356effd0033301c3d1a6296576efe2bb3bdc405"
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

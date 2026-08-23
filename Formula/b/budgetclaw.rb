class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.29.tar.gz"
  sha256 "fa3f86e8962dc8b8ebf956333741d87a03163c18a48e24dd0f51977c1a76b233"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68238740a95c74c86093ef92438915914151ca60392a3e782554dfd8eda114e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a97ded3111dd90545675e41f7a3736f706da4eecdb9cd2d826dbcf96480e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e41c18042a71ee90602cbe455ffd49b095cf02caeab7c83c384420f8f6d18bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3e3b1a6adb106a393d0a70f282610244476459001ab36e718b497c2de8515b3"
    sha256 cellar: :any,                 x86_64_linux:  "8a89110758eca0784fed78ded027af14717edd4fdf3557cbf5a6aeefd5aaeea9"
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

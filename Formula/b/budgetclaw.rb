class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4456afc2513d995079127a8a7058e3dc78b372bd6c2e44c7ae41c38b4c745ce9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346e5c7cd764be075d6a8d044a382337169dfbd7099da52c7b3e5c7063f3455d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c700200b199ffc5e8169fe866a91dc4688612b5296ee3578e2b93d234bb2fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5187933bac36e4768c428e4c313b3f5f914963d8bdc4b15e3e283b3a0b40fe6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4dc78e8c646c48b7f66fc946f19429ea9c27b2b91e12b92db3da424732a5c75"
    sha256 cellar: :any,                 x86_64_linux:  "84c7bb1a0e9f78e9d6c6ddeb2bd5496623f0658537e718b779c5e487b3e7c34e"
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

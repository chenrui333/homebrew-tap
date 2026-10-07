class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.83.tar.gz"
  sha256 "d2c5311a6c40e801147f3ecf0709a998d84e98625802c6e9e121e72cf50dbb5c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07c723dcf4f1b2140a02ef9c14c2614fc39e5f02343e9747ab41af3b69107a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946299d5456e4de5a39c59eb8e4e296c07646b719f910fb756315777b2f7b1c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a063a95517359302940bbab4d99e1240da557e031a2dd8a4e82a06926d7958"
    sha256 cellar: :any,                 x86_64_linux:  "1eb9597a3fee95b887a1acca3145c11d2dedb4f6bf2f43d89c56407eace1e1fc"
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

class SquadsCli < Formula
  desc "Open source CLI for AI agent coordination with domain-aligned squads"
  homepage "https://github.com/agents-squads/squads-cli"
  url "https://registry.npmjs.org/squads-cli/-/squads-cli-0.10.1.tgz"
  sha256 "5cd3d9dd0d17440d3001e53faeecf458591a84c277372058a5739df95572705f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ae133d8a2e9ba5b6e0af23abfd856d2f24a3d18c334da30d829b70b20c68f73c"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/squads --version")
  end
end

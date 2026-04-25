class SquadsCli < Formula
  desc "Open source CLI for AI agent coordination with domain-aligned squads"
  homepage "https://github.com/agents-squads/squads-cli"
  url "https://registry.npmjs.org/squads-cli/-/squads-cli-0.3.1.tgz"
  sha256 "aefca827b0a79e9b53a186911a6f469a4ed773e3e4aae129e96b9d648f5d69de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c3575c5284265db23c54af4b1e9687de8f399668979bd01a3cca6b506779cb8a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/squads --version")
  end
end

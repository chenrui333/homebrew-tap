class SquadsCli < Formula
  desc "Open source CLI for AI agent coordination with domain-aligned squads"
  homepage "https://github.com/agents-squads/squads-cli"
  url "https://registry.npmjs.org/squads-cli/-/squads-cli-0.8.3.tgz"
  sha256 "807d748ff79a1d7b2f0e2a9e8ae17dab30fc2952e3bc924f8ce5fb3a3ea892cd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "6df0f254fcb9920a117a7711e2bdf8af58695aed41f3da1ffda16a210b1614fe"
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

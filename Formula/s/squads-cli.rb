class SquadsCli < Formula
  desc "Open source CLI for AI agent coordination with domain-aligned squads"
  homepage "https://github.com/agents-squads/squads-cli"
  url "https://registry.npmjs.org/squads-cli/-/squads-cli-0.8.2.tgz"
  sha256 "9689e2230969d7719cc45ed2c6255df8ed1a5c4bfb9d34b4dc28c516d6d87bec"
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

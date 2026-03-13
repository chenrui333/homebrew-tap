class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.8.4.tgz"
  sha256 "65f447bbb9719207c2107b78df0ae8daf3ccf6c16226d66e2f9ca605d0a5e47a"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "77b7b3a4888f05f50b8f79edd4e7d29fae1dd0321aca7a5d8dfc05ceda0dad4a"
  end

  depends_on "node"

  def install
    inreplace "package.json",
              %r{"@longrun-ai/codex-auth": "\^[^"]+"},
              '"@longrun-ai/codex-auth": "^0.8.0"'

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds manual ws_read --lang en --all")
    assert_match "Toolset manual: ws_read", output
  end
end

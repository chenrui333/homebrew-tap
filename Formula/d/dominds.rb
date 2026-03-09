class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.5.1.tgz"
  sha256 "4271fa435ebf9b3892cbd42b9146d1802589327dc587784d0560e65db206cd3d"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "93a10bfe9e7705b869a21d00dd08ddeac4c46dbfba7a1eb18b37a88db5d254cc"
  end

  depends_on "node"

  def install
    inreplace "package.json",
              "\"@longrun-ai/codex-auth\": \"^0.9.0\"",
              "\"@longrun-ai/codex-auth\": \"^0.8.0\""

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds manual ws_read --lang en --all")
    assert_match "Toolset manual: ws_read", output
  end
end

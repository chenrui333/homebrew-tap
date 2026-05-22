class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.25.3.tgz"
  sha256 "61bc04f6afd486bfe8bd6660242be06da3a76bd6098fede15caff53bbb1f390d"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "38160dff960af04535beee002ca1b6e12bdb98b05cd044c00dad24db269a4bd3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds manual --list")
    assert_match "Available toolsets:", output
    assert_match "ws_read", output
  end
end

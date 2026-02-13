class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-0.8.11.tgz"
  sha256 "39ba2c00b0785fd479b9a3df8d02ed529c94d341ac5849ea6162f54abff8eeef"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e8b03a40a84b91103debe85e22cda69628144f33d89618a76c3f9e3320d6b568"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dominds --version")

    output = shell_output("#{bin}/dominds manual ws_read --lang en --all")
    assert_match "Toolset manual: ws_read", output
  end
end

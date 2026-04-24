class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.19.2.tgz"
  sha256 "a2e2265fd20a44c0e9973dc3234f5f97b51c8c7b59b2a4e34ea3338a04691b7b"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "6d16658ce0e11c4772774f8e453c4db6faaaa01c2f3f889eb2b59ec9b2d47af8"
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

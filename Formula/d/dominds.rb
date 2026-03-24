class Dominds < Formula
  desc "AI-driven DevOps framework with persistent memory"
  homepage "https://github.com/longrun-ai/dominds"
  url "https://registry.npmjs.org/dominds/-/dominds-1.9.1.tgz"
  sha256 "8d16a320bd6b78b016934c8f996e3a3dc46525d4e111560cc84d33c99e7e9392"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "19871636af3501c4b0c8d32e2ba088e049a1eaa6da7519776d52d9fad5ae2509"
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

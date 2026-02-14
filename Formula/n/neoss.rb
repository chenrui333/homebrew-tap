class Neoss < Formula
  desc "User-friendly and detailed socket statistics with a Terminal UI"
  homepage "https://github.com/PabloLec/neoss"
  url "https://registry.npmjs.org/neoss/-/neoss-1.1.11.tgz"
  sha256 "7d6390435eda02ca3157a3ca463e2db0282b774cab211d857bb322f423f2cee4"
  license "BSD 3-Clause"

  depends_on :linux
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/neoss"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neoss --version")
  end
end

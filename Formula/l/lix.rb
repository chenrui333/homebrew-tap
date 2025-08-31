class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-15.12.4.tgz"
  sha256 "4f2257276aba9f552b1b35237d33fbc1a0898039d8105ed6e8d1468e6c53a2fa"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/lix"
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/lix --version")
    system bin/"lix", "--version"

    output = shell_output("#{bin}/lix scope create 2>&1")
    assert_match "created scope in #{testpath}", output
    assert_equal "stable", JSON.parse((testpath/".haxerc").read)["version"]
  end
end

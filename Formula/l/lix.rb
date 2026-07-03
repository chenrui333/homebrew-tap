class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-17.0.1.tgz"
  sha256 "e066210b37e63b4a7374a9dacf736bfe87b49c9da0cabb00b8af17ad312fe3b0"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b6e50d8530133acc1d43d1faed144d428e981bf615e021c358f855ce9891f202"
  end

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

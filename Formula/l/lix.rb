class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-17.0.3.tgz"
  sha256 "f96b93227f2f2fc0dd1237e998aec26b4aea223222789d79367cc36f2f62f93a"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f18dfdd11ae0431185a8a242b69be65bc5801f0034274f7f70396bffeee5f44d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/lix"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lix --version")

    output = shell_output("#{bin}/lix scope create 2>&1")
    assert_match "created scope in #{testpath}", output
    assert_equal "stable", JSON.parse((testpath/".haxerc").read)["version"]
  end
end

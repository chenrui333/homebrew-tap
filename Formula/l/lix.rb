class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-16.0.2.tgz"
  sha256 "02f513a86e07ed149d876459f2bc210dce136cf5b41b7e1f34eb99be120cc4e5"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "74fbff9cd207eb2d2ee598d9397026845321672cc912c6c7f05d6d4c935c686b"
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

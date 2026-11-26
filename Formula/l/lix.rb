class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-17.1.0.tgz"
  sha256 "99a8de978fcc3ef1a27ea2f5bbcdc4578cdfd92b4df042a7a45a51bbe9903b2f"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b80740a8062d4c876d9dd6e402c75657692c921f419e74bd068e737a6805b3c1"
    sha256 cellar: :any_skip_relocation, all: "415eb5de8026c9b8bb939bae5fea0cd6eba1cf4997632fb07198f2cc1e887fd9"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/lix"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lix --version")

    output = shell_output("#{bin}/lix scope create 2>&1")
    assert_match "created scope in #{testpath}", output
    assert_equal "stable", JSON.parse((testpath/".haxerc").read)["version"]
  end
end

class Lix < Formula
  desc "Dependable package manager for your Haxe projects"
  homepage "https://github.com/lix-pm/lix.client"
  url "https://registry.npmjs.org/lix/-/lix-15.12.4.tgz"
  sha256 "4f2257276aba9f552b1b35237d33fbc1a0898039d8105ed6e8d1468e6c53a2fa"
  license "MIT"
  head "https://github.com/lix-pm/lix.client.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba75512470de526901eb3731910868ef379595fe1876eba7c776178330255dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4290812b9ff7f233cff6b3ef29394018277c4a4f992a223f1306bdb51d4e66d1"
    sha256 cellar: :any_skip_relocation, ventura:       "a836ff154cac4eeddea30d33d83fefeae8f73de330e46f4df2024efe0e4717d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190610747a01d4f0b1e9908136b99dede842cc5313c1c8bf3a660d8b783a1c56"
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

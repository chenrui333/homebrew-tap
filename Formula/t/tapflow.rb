class Tapflow < Formula
  desc "Self-hosted iOS and Android simulator streaming for the whole team"
  homepage "https://github.com/jo-duchan/tapflow"
  url "https://registry.npmjs.org/tapflow/-/tapflow-0.18.0.tgz"
  sha256 "7e996e04414ac7155c70d36d645a82791fc4d0ba78044725315624d850d6f471"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "118a99fed00ea3eafcd4b72c5b40573f2a7c83269c766d2acb996c207891c514"
  end

  depends_on :macos
  depends_on "node"

  on_macos do
    depends_on macos: :tahoe
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tapflow --version")

    output = shell_output("#{bin}/tapflow admin not-a-real-subcommand 2>&1", 1)
    assert_match "Unknown subcommand: admin not-a-real-subcommand", output
  end
end

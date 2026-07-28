class Tapflow < Formula
  desc "Self-hosted iOS and Android simulator streaming for the whole team"
  homepage "https://github.com/jo-duchan/tapflow"
  url "https://registry.npmjs.org/tapflow/-/tapflow-0.17.0.tgz"
  sha256 "f230f7f47300886639a63187fa1a6b83d3d91ab56fffee7479c4c641b90ad376"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9fe62cf15c89d3951f5b9b728e4451a9db7c313ea90e28043ba82cc562b81ec1"
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

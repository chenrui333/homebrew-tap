class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.6.0.tgz"
  sha256 "80dcd7798c8c21285b719b1de1616992c048dae3dd9b316dc39237c7e842d524"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "f9916b058fcd93d476996e1b923b0f847712a929bec37b3e0c5938380dd6029f"
    sha256               arm64_sequoia: "f9916b058fcd93d476996e1b923b0f847712a929bec37b3e0c5938380dd6029f"
    sha256               arm64_sonoma:  "f9916b058fcd93d476996e1b923b0f847712a929bec37b3e0c5938380dd6029f"
    sha256 cellar: :any, arm64_linux:   "3bcb803dd28a4886a6aff9dc7f29458c497b68d91a179bfbd3bd8797354849c7"
    sha256 cellar: :any, x86_64_linux:  "b9e0829d95dc0c4dc425f40c01b796375d37d25194343e22563497ce55c0acf5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    native_prebuild = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds.children.each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != native_prebuild
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

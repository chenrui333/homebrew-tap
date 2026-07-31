class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.4.tgz"
  sha256 "5d9ecff7db52ce662feb4be644fc74887370013a4bfc192cb17b7891cb0ba086"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "7e6adc7cfd73320e57a7d4ac34015f7870ac711b96b2ed62acc88c5c572e7692"
    sha256               arm64_sequoia: "7e6adc7cfd73320e57a7d4ac34015f7870ac711b96b2ed62acc88c5c572e7692"
    sha256               arm64_sonoma:  "7e6adc7cfd73320e57a7d4ac34015f7870ac711b96b2ed62acc88c5c572e7692"
    sha256 cellar: :any, arm64_linux:   "357176d6b46e7ff39663ab2c8535fc3396930ef3d46e8622201f2c5ee6f448a3"
    sha256 cellar: :any, x86_64_linux:  "4f6e046c0b97a23eeff23eee3fd49b74177b5e2a6707c468f4f3faf604383777"
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

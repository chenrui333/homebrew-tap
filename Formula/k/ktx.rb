class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.14.0.tgz"
  sha256 "9a550b215def4c0099e530d7d9bf09842868f708a5df1a7fa4ed46ecb3c04bb9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "15282e01f30ff5babd3be83651f1221db4cc95e970dfcf54655e2d07adc477bd"
    sha256               arm64_sequoia: "46a284bb862637fdc29e426414548e8dcf7a99e4fbfe2fc7b89406ada09e0294"
    sha256               arm64_sonoma:  "46a284bb862637fdc29e426414548e8dcf7a99e4fbfe2fc7b89406ada09e0294"
    sha256 cellar: :any, arm64_linux:   "7337ec9214d99fcd86a9d278a4a4fed5a008430b501a4302f82b8a7fe1834a15"
    sha256 cellar: :any, x86_64_linux:  "603e840a209ef9423c166b930f0a7596438a08af0b9c1668dcb050bf9c74f941"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = OS.linux? ? "#{os}-#{arch}-gnu" : "#{os}-#{arch}"
    minicore_dir = libexec/"lib/node_modules/@kaelio/ktx/node_modules/snowflake-sdk/dist/lib/minicore/binaries"
    minicore_dir.each_child { |binary| rm binary unless binary.basename.to_s.include?(native) }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktx --version")

    output = shell_output("#{bin}/ktx not-a-real-command 2>&1", 1)
    assert_match "unknown command 'not-a-real-command'", output
  end
end

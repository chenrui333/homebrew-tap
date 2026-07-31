class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.4.tgz"
  sha256 "5d9ecff7db52ce662feb4be644fc74887370013a4bfc192cb17b7891cb0ba086"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "3cf09bae482e73a2835d6b4de90e1e710b0b7611ff0f64d4de5d2b581af5722b"
    sha256               arm64_sequoia: "3cf09bae482e73a2835d6b4de90e1e710b0b7611ff0f64d4de5d2b581af5722b"
    sha256               arm64_sonoma:  "3cf09bae482e73a2835d6b4de90e1e710b0b7611ff0f64d4de5d2b581af5722b"
    sha256 cellar: :any, arm64_linux:   "7acb68cfed8c527170f3ec30b4b7f8d0348dd77505e2164d4f332060a2da358c"
    sha256 cellar: :any, x86_64_linux:  "f53f94efe235ec17a4ff586c0c29f7173b029d4b4688665d99439ff23d4c6a45"
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

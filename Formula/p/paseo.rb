class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.6.0.tgz"
  sha256 "80dcd7798c8c21285b719b1de1616992c048dae3dd9b316dc39237c7e842d524"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "3bce30068e5bfa6a605d145ccfbf131dc08fb9667b3576961f938b7f61a1fea9"
    sha256               arm64_sequoia: "3bce30068e5bfa6a605d145ccfbf131dc08fb9667b3576961f938b7f61a1fea9"
    sha256               arm64_sonoma:  "3bce30068e5bfa6a605d145ccfbf131dc08fb9667b3576961f938b7f61a1fea9"
    sha256 cellar: :any, arm64_linux:   "54235de79b0d0a0c2aaa67a7c48bfd54bcf7b07e8acce2b5d92aa71b143558b2"
    sha256 cellar: :any, x86_64_linux:  "61023bb71b0cebe17130badc429cc804143e35efe6f83e0a8dbeaac6818ab5a2"
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

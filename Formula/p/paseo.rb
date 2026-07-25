class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.1.tgz"
  sha256 "271193c4f5a6a355e82a83a661d9d597b668963276d118711caf5c551727bd1c"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "b8e084ec3f394c26bfb667356af5970d3c14bfd435710df188c66f1a6e544714"
    sha256               arm64_sequoia: "b8e084ec3f394c26bfb667356af5970d3c14bfd435710df188c66f1a6e544714"
    sha256               arm64_sonoma:  "b8e084ec3f394c26bfb667356af5970d3c14bfd435710df188c66f1a6e544714"
    sha256 cellar: :any, arm64_linux:   "45bf548443bc27f89d7f7bb4ca5088bd16257aa29c78b7331f2dce4ea2c40eef"
    sha256 cellar: :any, x86_64_linux:  "f4d37a30b3924aae36ccbe9bbcf18a5239bfea8af812634eb6f3f0964a51d232"
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

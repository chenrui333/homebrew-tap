class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.10.0.tgz"
  sha256 "216030a379ac4f6b5fed392064b328e446dce687aa3951da43d728a70212dfe9"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "49aed1fdc00f23d4bd7fdca5a9b6444bdd96b45c8577805fcbe5de757aa16ecb"
    sha256               arm64_sequoia: "49aed1fdc00f23d4bd7fdca5a9b6444bdd96b45c8577805fcbe5de757aa16ecb"
    sha256 cellar: :any, arm64_linux:   "eac4e48bd1208e263405afbf80da9dd648d5644323d864b87fe4a061c43ec09e"
    sha256 cellar: :any, x86_64_linux:  "76c37390a41f263d2e1bdc981ffcc7e850fe7c897ee4b89b2a74873bfe0f9d40"
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

    # Homebrew Linux uses glibc; the optional musl binaries reference libc.so.
    if OS.linux?
      libexec.glob("lib/node_modules/@getpaseo/cli/node_modules/@msgpackr-extract/*/*.musl.node").each do |file|
        rm file
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

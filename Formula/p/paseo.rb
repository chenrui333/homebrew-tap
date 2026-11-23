class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.17.1.tgz"
  sha256 "4601ce31a9efbf42c4bc176dfe997ef5acb3177899a663354c45ded9392d9eb5"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6b8744b067870209585793f37c56db82a591500745d815134d12efb500e02a27"
    sha256               arm64_tahoe:   "59415941855010e341c83b71f45d313b16a660b1e9fef9cc1070f2c9636b9b62"
    sha256               arm64_sequoia: "59415941855010e341c83b71f45d313b16a660b1e9fef9cc1070f2c9636b9b62"
    sha256 cellar: :any, arm64_linux:   "4274dbaebe18465b9fce7e08922cece638541e9edf7147cbb43aac0cd87da082"
    sha256 cellar: :any, x86_64_linux:  "b88c60c53bf338192cf66e750185e938a38c3158644345ec6ab42bde43c19f85"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    native_prebuild = "#{os}-#{arch}"
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

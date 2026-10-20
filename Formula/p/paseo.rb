class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.12.0.tgz"
  sha256 "51843851f5a9c14f7b22d2c6c4970357ff602781c1bddfd9c97de55cc03b5aa3"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "501aaf5b71a3db3323f4e582467212375544ffdd3c7dec6c332c06c8a1b627cf"
    sha256               arm64_sequoia: "501aaf5b71a3db3323f4e582467212375544ffdd3c7dec6c332c06c8a1b627cf"
    sha256 cellar: :any, arm64_linux:   "a8c38a7dec2574ae9a5b0ff09878698a2c1e0d1d8ff86f99bcc90d8b8acf1cad"
    sha256 cellar: :any, x86_64_linux:  "2625a357c8463d0f3c47f3f738db5496e8d8d7f32715337d70f4694b4ee76f70"
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

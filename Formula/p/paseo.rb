class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.11.0.tgz"
  sha256 "823040e94cd7d1ad631e8248e2d05d2bb647a1610f33bfe574abc4d37b7d129b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "2e1e928dc9053362a37701d2f3ac4198f176583a6ee12701945733dd9d1f8d67"
    sha256               arm64_sequoia: "2e1e928dc9053362a37701d2f3ac4198f176583a6ee12701945733dd9d1f8d67"
    sha256 cellar: :any, arm64_linux:   "519b482f8d95283d165c5fc6677801d85b79c30cbc13e4c38524494523d4f4cc"
    sha256 cellar: :any, x86_64_linux:  "33739e75b7d8bb2d9547eb3b0f8e8ab19c788513e27e49c454ad4fbec0870d8d"
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

class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.17.4.tgz"
  sha256 "1dbfffdc99718374801e787b6948f350bd2f63459e2031053c42534c1e078504"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "866944614dd88186854a6a33c2795aef0b4789fdfe0dcf4b3131a3865ecd6b46"
    sha256               arm64_tahoe:   "3d25c4233a06fa05f5e7bf65d48c5a8d19c413c3dae25e16e4b27455e11b72a9"
    sha256               arm64_sequoia: "3d25c4233a06fa05f5e7bf65d48c5a8d19c413c3dae25e16e4b27455e11b72a9"
    sha256 cellar: :any, arm64_linux:   "14efd31a2b3afc625224580be81a3aaca73d906058ed1f04c81548806a69c2fd"
    sha256 cellar: :any, x86_64_linux:  "c68c47d029a521aafedcb1d6ed04261880bb8eb68c021dc10d506fc25933a9c5"
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

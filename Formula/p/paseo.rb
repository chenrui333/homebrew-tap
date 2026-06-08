class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.90.tgz"
  sha256 "7b1d588f96fec4b1708c84fa9b29debf12220dc72b75bee163f295e1c504cf56"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "739bc3826ec859408990d6679532f2457f539cecbbd0fd5f8235fb2a43c1923f"
    sha256               arm64_sequoia: "6ece689430c11d674e3106acb8c39aca391aea65d112bff5d4a03c83a10024c7"
    sha256               arm64_sonoma:  "6ece689430c11d674e3106acb8c39aca391aea65d112bff5d4a03c83a10024c7"
    sha256 cellar: :any, arm64_linux:   "734b640ec0cbe630a2fb26dd216a32049302968e0ca3a0354128957f270e3737"
    sha256 cellar: :any, x86_64_linux:  "2ee210a5d7692264bd9b454a4b575d70531157e30a356c1800c0f40baca14b87"
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
    assert_match "paseo", shell_output("#{bin}/paseo --help")
  end
end

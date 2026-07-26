class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.2.tgz"
  sha256 "8466f54efc9d0a25c89fc9f7a9047ebb7b403b08d985c5e34e771a0f55581e1b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "531f51954d060751720542a9bfad798e56b47c30dec8cec0559c3157044587c6"
    sha256               arm64_sequoia: "531f51954d060751720542a9bfad798e56b47c30dec8cec0559c3157044587c6"
    sha256               arm64_sonoma:  "531f51954d060751720542a9bfad798e56b47c30dec8cec0559c3157044587c6"
    sha256 cellar: :any, arm64_linux:   "8f5ac73628a9e287ebadef1b82436198d42fc6c90596b61d2d4fbb01f8adbf82"
    sha256 cellar: :any, x86_64_linux:  "19082a3f92292025a845592343e8ebb9812ab98bbd485232ac73c4d70e7a6f09"
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

class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.7.2.tgz"
  sha256 "b966a35051d531614a1cb29c09492cfdb8b394f0f2ab1c80a7e6b70e157f545a"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "38b5c7ef5568381212772a0e29e56d0ade9e8faa1bdcdd8522bb2fda3fc5f6d1"
    sha256               arm64_sequoia: "38b5c7ef5568381212772a0e29e56d0ade9e8faa1bdcdd8522bb2fda3fc5f6d1"
    sha256               arm64_sonoma:  "38b5c7ef5568381212772a0e29e56d0ade9e8faa1bdcdd8522bb2fda3fc5f6d1"
    sha256 cellar: :any, arm64_linux:   "88edaa5f3e81a5041d7a8bef015012208b1649afc350ba4bec6c5080748db822"
    sha256 cellar: :any, x86_64_linux:  "6218549b0686b2f8d7742d2c27d4cc5d1cc374cd35222361318df960c452cd38"
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

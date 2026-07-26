class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.2.tgz"
  sha256 "8466f54efc9d0a25c89fc9f7a9047ebb7b403b08d985c5e34e771a0f55581e1b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "f180f8375b9ebf6841af458b26104a84234c17844bc0f1442b95260c3415de98"
    sha256               arm64_sequoia: "f180f8375b9ebf6841af458b26104a84234c17844bc0f1442b95260c3415de98"
    sha256               arm64_sonoma:  "f180f8375b9ebf6841af458b26104a84234c17844bc0f1442b95260c3415de98"
    sha256 cellar: :any, arm64_linux:   "e1db980cf5da0c1a67dca7c60728fea5d207b31dfb7c7e3938268029ee2f6489"
    sha256 cellar: :any, x86_64_linux:  "10b5e2705d3231c8ea7c611d222c5841af33549fd221e893ab9935a6ab7a55fa"
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

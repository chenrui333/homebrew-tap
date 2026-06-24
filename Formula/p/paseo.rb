class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.99.tgz"
  sha256 "ed8d04192d5f301d604629bcd472a4a4356ff824c648f1003de676132b509b41"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "0759500d6b8fee80a131eb4eb1d30f5741ba85cb2a9e2821020f8644b2ac0cd3"
    sha256               arm64_sequoia: "049daca935261e146b722eb0ae0d0727efb5ce779895d5305001ea99fbf1b38b"
    sha256               arm64_sonoma:  "049daca935261e146b722eb0ae0d0727efb5ce779895d5305001ea99fbf1b38b"
    sha256 cellar: :any, arm64_linux:   "78b2a03ea0da7946946e1dc5d19b493c6ca0acacf7cf07b5659e69f69b3bf513"
    sha256 cellar: :any, x86_64_linux:  "2e49a1247c04cf75bffb8710de004fb4a638a653c1a94a013b90c67f8e4675f9"
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

class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.106.tgz"
  sha256 "178561c76f7662efd0b3e21fafaec14a4de2a46964e54ce6f943c7db30dd0998"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "9178e010e74e0c585a1db2d92aff2cc1c788cc0d55c50ef33275a754784255f3"
    sha256               arm64_sequoia: "c5942c44185a4edcd3ea731e8ce9e214502609871e7d966215bf301e5e6cbe77"
    sha256               arm64_sonoma:  "c5942c44185a4edcd3ea731e8ce9e214502609871e7d966215bf301e5e6cbe77"
    sha256 cellar: :any, arm64_linux:   "79c886edf2f7b852478af84ec3ab58ddeaa050a6ef75934221ea35f47d4ab99e"
    sha256 cellar: :any, x86_64_linux:  "25080571b2ff58c8355f4aa2573660f08963094374192587c45d1c39954f833c"
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

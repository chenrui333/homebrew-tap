class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.102.tgz"
  sha256 "a6d2430f7bb4a26b316d9e80d0c64cfa5199a2664b8c3abf7a3cdef298e107b8"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "fa16e865d59c48fc08baa8ea36a6d53ce08ab64b351f9b025a0db67accdf370f"
    sha256               arm64_sequoia: "4170a17557c16adaf320075b2136fa259463d47439be435da007151fce01f4ee"
    sha256               arm64_sonoma:  "4170a17557c16adaf320075b2136fa259463d47439be435da007151fce01f4ee"
    sha256 cellar: :any, arm64_linux:   "7e81d7df977c4b247ff42f7acf08b37ed54379da16b327d230e62b3f25f08765"
    sha256 cellar: :any, x86_64_linux:  "1758f88ceefeba2df31965f74da73fa923847458bcf09b1a07d3a959296a0ced"
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

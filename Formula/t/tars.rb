class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.31.0.tgz"
  sha256 "8475585cafc20423728364602b34e3a4c9ebac0dd8ad8858010b3a4107f73895"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c743897feec40b0a8297df3b99f8c1dc16b83f2795ef8069db40fa940a8671f3"
    sha256 cellar: :any,                 arm64_sequoia: "e86264a7375ea80e8fd0822442625a25599abfd8533c26f43bdceba599de76fc"
    sha256 cellar: :any,                 arm64_sonoma:  "e86264a7375ea80e8fd0822442625a25599abfd8533c26f43bdceba599de76fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e7ab76ed47db9347f2126df4ac67a5cf0edcf9e99438f679ee4e3478ca57a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4a6a43ebab8bf246f8ac111ad46a038714f470fa747209563f93fc2d3e7def"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds to avoid linkage issues
    nm = libexec/"lib/node_modules/@saccolabs/tars/node_modules"
    if OS.linux?
      nm.glob("**/prebuilds").each { |dir| rm_r(dir) }
    else
      native = "darwin-#{(Hardware::CPU.arch == :arm64) ? "arm64" : "x64"}"
      nm.glob("**/prebuilds/*").each do |dir|
        rm_r(dir) if dir.basename.to_s != native
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tars --version")
  end
end

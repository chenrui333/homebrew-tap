class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.9.0.tgz"
  sha256 "a1057a1d86e03980b33b3668fd53c634552718399f44fcf1f55d841f28f064b0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b027fa6e555893521d4ddd5dbe2566e5ba84911531a71a021c0464d1a333cde5"
    sha256                               arm64_sequoia: "b027fa6e555893521d4ddd5dbe2566e5ba84911531a71a021c0464d1a333cde5"
    sha256                               arm64_sonoma:  "b027fa6e555893521d4ddd5dbe2566e5ba84911531a71a021c0464d1a333cde5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c838d5cb38a1f4e438b963d31a3154e31f388b0ae1609e2a985cf5dd6a5412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31927e21907b709db89123fae88987949d48c818225f8c9b85934e34d7d72112"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end

class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.6.tgz"
  sha256 "bd8f9974380e6f4b798c81f1e02c8e50f44d948b1ddaf82e04a333ad98a9312e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1145e76365caee25b5d63b5971626b3ee4616625f911abef19ca66cf864fcafe"
    sha256                               arm64_sequoia: "1145e76365caee25b5d63b5971626b3ee4616625f911abef19ca66cf864fcafe"
    sha256                               arm64_sonoma:  "1145e76365caee25b5d63b5971626b3ee4616625f911abef19ca66cf864fcafe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f9b6760018474325c59da9248bb67d6fcda00322e62ca56c03f140855c979b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "017ed69b1c81aaa2d0a60bd1e3ce9f01a67772441d02ec41cd6b65b9a2f82808"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end

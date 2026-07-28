class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.24.0.tgz"
  sha256 "110321296b2335aaa8e127f6cfe94968842f45722e18a8270f0b76534a61a187"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dca257971b1fc16fd1627cd94db28ee72cf54f3a530ad15bc81c68b9ed9871e7"
    sha256                               arm64_sequoia: "dca257971b1fc16fd1627cd94db28ee72cf54f3a530ad15bc81c68b9ed9871e7"
    sha256                               arm64_sonoma:  "dca257971b1fc16fd1627cd94db28ee72cf54f3a530ad15bc81c68b9ed9871e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fd51ab83f2f2a214f5876a8645a13f4bc6bf9971c56c77de3760b408edb8a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b1bcda4dc31592a3c49e1d9319e3cd164e36212e93bdba0d1294be739c16db"
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

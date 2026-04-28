class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.17.2.tgz"
  sha256 "5f8d7d830e29556b77449fb682ba2021512c1562a7d5cf14b2b1ba8af80caef5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1eb0ef888a0af2642cd1c6bdb2b43dd373be2c8e92eeb5a750f67aecac581488"
    sha256                               arm64_sequoia: "1eb0ef888a0af2642cd1c6bdb2b43dd373be2c8e92eeb5a750f67aecac581488"
    sha256                               arm64_sonoma:  "1eb0ef888a0af2642cd1c6bdb2b43dd373be2c8e92eeb5a750f67aecac581488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e4f13fe57be8a805abbb72f1fb506f0b38353af27d52aa875d3bd544dc980b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d690db0e6032332538bd71ac69eafa4a8d7ff30d768889c52c09cc009365c1d7"
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

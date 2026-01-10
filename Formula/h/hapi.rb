class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.7.2.tgz"
  sha256 "58a435ee210b4f57191d934eec3613ec419318153a251d4523fb1de2ef770ffc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7d91513675c659ea80117eacb6a41c691ff0394c9b7bcbdcabaf1c31e2feed59"
    sha256                               arm64_sequoia: "7d91513675c659ea80117eacb6a41c691ff0394c9b7bcbdcabaf1c31e2feed59"
    sha256                               arm64_sonoma:  "7d91513675c659ea80117eacb6a41c691ff0394c9b7bcbdcabaf1c31e2feed59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22262f6aede9d3b6e78dd9a65f41145a728ae25787da9bb7324f1b3f8ebee1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd3962b796a579dcb013de7d355757fbfba2aef0011d731c4f113e17e17fe64"
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

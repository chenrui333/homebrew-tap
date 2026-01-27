class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.13.0.tgz"
  sha256 "1338cd2acfc267138258036d6e1fc643ee787211fd560ca92357ec95e285dd78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "90fa3acff7761e7463011e36eaf1af9704d375eeb35caca7905c3a0d8d2c391f"
    sha256                               arm64_sequoia: "90fa3acff7761e7463011e36eaf1af9704d375eeb35caca7905c3a0d8d2c391f"
    sha256                               arm64_sonoma:  "90fa3acff7761e7463011e36eaf1af9704d375eeb35caca7905c3a0d8d2c391f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68a03fb4771ad84012db74a929da737391556128e90210eab396ed5981c4138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7498ab837afeab758b8d4c04e358125d2aa8f56fb498611942e2d65fafa611"
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

class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.11.0.tgz"
  sha256 "1e913a69c4de6ad0c998a555643fa31060f95d7e91980a8072e05f3b4088f544"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "890218178f4f15816c1055fe565a857ade536c8793450b15c391841ee80680c9"
    sha256                               arm64_sequoia: "890218178f4f15816c1055fe565a857ade536c8793450b15c391841ee80680c9"
    sha256                               arm64_sonoma:  "890218178f4f15816c1055fe565a857ade536c8793450b15c391841ee80680c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25a6c1330b2a3d26dd4df40b999d3104bcdae86c3540e7321c737a7eff97d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569e5d1e330e90d6911b91a4647e9abc03061d42035392a9414587059992f76e"
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

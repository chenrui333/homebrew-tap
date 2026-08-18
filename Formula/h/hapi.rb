class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.28.0.tgz"
  sha256 "f749bb8e24a6566d5cb519c6f29921846b955ade2f0c2f723ce87110ae3b5a21"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a10ea2f671d7ba6de149a8abf58f04ed2217ce7bc4527f2c56330cd591f61dfa"
    sha256                               arm64_sequoia: "a10ea2f671d7ba6de149a8abf58f04ed2217ce7bc4527f2c56330cd591f61dfa"
    sha256                               arm64_sonoma:  "a10ea2f671d7ba6de149a8abf58f04ed2217ce7bc4527f2c56330cd591f61dfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49208b1e965d74a2eec6caa9f69ffa4bd49062cc327c7ff3a37af51daf000dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d02a062cd45603879e186adb00ace8eb78866d7dcfcfa6cf3f33c3ccd1b2d2"
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

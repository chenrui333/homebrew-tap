class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.25.4.tgz"
  sha256 "119aabaacf205f86d18933581b13754254a8a602d6b72d61e53713ce08c076b8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a30a39e23ab94647c53760f7a06a8b9edd76b2232696d177b52a4017cd66634e"
    sha256                               arm64_sequoia: "a30a39e23ab94647c53760f7a06a8b9edd76b2232696d177b52a4017cd66634e"
    sha256                               arm64_sonoma:  "a30a39e23ab94647c53760f7a06a8b9edd76b2232696d177b52a4017cd66634e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "218504de32d838639875bfd8044514c72efb9c77c33b65a46daf6c1f361fe1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c154570aeef9529bee3e99f7230948696971a8dc44c6af58e982da20233de8"
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

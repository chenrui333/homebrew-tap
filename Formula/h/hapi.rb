class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.25.4.tgz"
  sha256 "119aabaacf205f86d18933581b13754254a8a602d6b72d61e53713ce08c076b8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1a53668ec2fbf9d01e68f5be2ddde6ae4a047f94610d4afd8cd152fe17b2cf5f"
    sha256                               arm64_sequoia: "1a53668ec2fbf9d01e68f5be2ddde6ae4a047f94610d4afd8cd152fe17b2cf5f"
    sha256                               arm64_sonoma:  "1a53668ec2fbf9d01e68f5be2ddde6ae4a047f94610d4afd8cd152fe17b2cf5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a9007a40d34b46e80162c04095b552ada86f3db7ce178ffe67a1cfec80bd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95f08489440314b312b27cdd00384668bf023e87b02aa0301f59fb6bb2a371ae"
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

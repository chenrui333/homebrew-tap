class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://github.com/superagent-ai/vibekit"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.4.tgz"
  sha256 "0d636445799fc10b0b9c46ad84030f562cddc1f9f70d010fe59357c3f871c19a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "530675fd5d137b7c1497484179bb3cfcc8f687d4e424d4bc4fb5cb4e6238dfe3"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibekit --version")

    # The status depends on whether the runner has a container runtime, not on the platform.
    assert_match(/Status: (?:EN|DIS)ABLED/, shell_output("#{bin}/vibekit sandbox status"))
    assert_match "No analytics data found", shell_output("#{bin}/vibekit analytics --summary")
  end
end

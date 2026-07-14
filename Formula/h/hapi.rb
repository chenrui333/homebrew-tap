class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.22.3.tgz"
  sha256 "315b52d28c2e06644286fd4723c6469d40b1d91abe57a125957f321d31874702"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1581cfefe51b832c0821f6a6af0fff7d36309abc6d62320f314110a4174b3f22"
    sha256                               arm64_sequoia: "1581cfefe51b832c0821f6a6af0fff7d36309abc6d62320f314110a4174b3f22"
    sha256                               arm64_sonoma:  "1581cfefe51b832c0821f6a6af0fff7d36309abc6d62320f314110a4174b3f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f62ab0f06c742dcf2c912b04644a6fd95f6f28ee6236a8298638711fdc51bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9245828f0d6075254cb93ac9418a3eea178b5a196d66738dfcdf341e3e985928"
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

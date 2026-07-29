class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.25.0.tgz"
  sha256 "b63ad6a8e590644e1bb67f10680a0405318d3cce5ed3f933095492f9fdfba5d6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "c0ff42de6723dd4b2ed2718f9b79fcbcc04b57670c669c436c07c551d11bc828"
    sha256                               arm64_sequoia: "c0ff42de6723dd4b2ed2718f9b79fcbcc04b57670c669c436c07c551d11bc828"
    sha256                               arm64_sonoma:  "c0ff42de6723dd4b2ed2718f9b79fcbcc04b57670c669c436c07c551d11bc828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a342da5e6e4996578daeff40385e3732432c1de7828ffd573e47a47868a73902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123fa5db8016d0a52ffc16d03e2e0af33afd8a6fe51ee9221ee90660c5ab41d6"
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

class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.22.3.tgz"
  sha256 "315b52d28c2e06644286fd4723c6469d40b1d91abe57a125957f321d31874702"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9796915669d09d9f9166c93d5a84a527545b1cbe39b919adffb8b647e474cfb5"
    sha256                               arm64_sequoia: "9796915669d09d9f9166c93d5a84a527545b1cbe39b919adffb8b647e474cfb5"
    sha256                               arm64_sonoma:  "9796915669d09d9f9166c93d5a84a527545b1cbe39b919adffb8b647e474cfb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a69318e6f7221c719ceee621eecd6b2e487d6a73d6638ec99e7748004644e3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfc68e129459ea805fff53636f0b38ec58b31f0b6e5d2cdbba5da2622578693"
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

class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.18.3.tgz"
  sha256 "6f53222b85eb9fd5aac9cf4eb42f9d70a8e60c7c644032293cf8f571df791b32"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a002176e3746ca51b63135a617babd8a9239c3eab6da32552c100f81cc38d17c"
    sha256                               arm64_sequoia: "a002176e3746ca51b63135a617babd8a9239c3eab6da32552c100f81cc38d17c"
    sha256                               arm64_sonoma:  "a002176e3746ca51b63135a617babd8a9239c3eab6da32552c100f81cc38d17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9d92c945f5baa430954bea99cdeab4cac6e37c4899de166e880e8d47f64b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a8dbb583425fc5505345fa206d0c1467bd0232d276983c36f6c57b32390f07"
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

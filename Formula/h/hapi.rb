class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.27.1.tgz"
  sha256 "42c1ebb51c3a156c4ec396004100575d5d09c0045bc6bbdb78adb6d7fc0f5ee6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0988af8d122258c24f4a6ce2ff0874195c7d39ab5466a3a7066955142461b04b"
    sha256                               arm64_sequoia: "0988af8d122258c24f4a6ce2ff0874195c7d39ab5466a3a7066955142461b04b"
    sha256                               arm64_sonoma:  "0988af8d122258c24f4a6ce2ff0874195c7d39ab5466a3a7066955142461b04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721b5fcdc19323c867ae6272043a3ecf56104bec9b0f803ea2535a24a5780057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cdbe544cfadfc1d266f29512ed4cce85b15df4fb05ce02f939f68dd61f28e7"
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

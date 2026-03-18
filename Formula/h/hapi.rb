class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.2.tgz"
  sha256 "8e3a9988d5a51e131548e343a6693a59d38e58b3923c437572d9119917336631"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "45d5c32c7492c915e35fad97f85e3b3618bab9930e73dbcbf77bb55225aa956e"
    sha256                               arm64_sequoia: "45d5c32c7492c915e35fad97f85e3b3618bab9930e73dbcbf77bb55225aa956e"
    sha256                               arm64_sonoma:  "45d5c32c7492c915e35fad97f85e3b3618bab9930e73dbcbf77bb55225aa956e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab19083b9a547aefdd27e165fc5505d3de3b88368518cb8d3d8d2c496acc753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e224c9324a6bf0e7643d2f05420fa5b1b0b7efcabfd9a3f39ca2526da6880b65"
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

class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.3.tgz"
  sha256 "12fc60eed05337b06075b37ca295458ea10206bd0f8a8359ecb473bbda408009"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5cdffc6ac98f1a2398b48e5cb0cc594ef39f53b3ded923127989347b56a10c31"
    sha256 cellar: :any,                 arm64_sequoia: "2f2e4da18291c248430bdde84083108dc2b76b14a8592904e7c3c1abb9732494"
    sha256 cellar: :any,                 arm64_sonoma:  "2f2e4da18291c248430bdde84083108dc2b76b14a8592904e7c3c1abb9732494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ea1b0e41ee9086be8d3f6d52568106478b5c16545d86a1b685718419e71332a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd48b4f078fd20384c41215ca80f8f1f20b7fc07b0c94aff92fe600d67d87b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end

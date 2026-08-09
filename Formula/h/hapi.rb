class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.27.2.tgz"
  sha256 "e9174cc9a40f68ab5e367b1a78c419714f092c597814f64ecc4fb42f91c8a519"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d8a7aa3ecfb2030e746e6c4770b572bfc3e8ca4e1d0dc3abd20eb497a8b7b2ee"
    sha256                               arm64_sequoia: "d8a7aa3ecfb2030e746e6c4770b572bfc3e8ca4e1d0dc3abd20eb497a8b7b2ee"
    sha256                               arm64_sonoma:  "d8a7aa3ecfb2030e746e6c4770b572bfc3e8ca4e1d0dc3abd20eb497a8b7b2ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a039d304be903078f9fa5efd86c06f7f9245cc315036798f8da896f1be1eb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dffedb0b837d0219cf1f43e1013cd47bf14e727f0209036f0d414f95f06e1847"
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

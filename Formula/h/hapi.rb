class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.15.4.tgz"
  sha256 "4c02d07d80f1440433abc2553c999338187ac1c7eae1449eabb5eace6dd6c63d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ecc85ac05e826d4bfccd8ba8b3ead2d2db52e73bf55860e0f8f68168a61b0144"
    sha256                               arm64_sequoia: "ecc85ac05e826d4bfccd8ba8b3ead2d2db52e73bf55860e0f8f68168a61b0144"
    sha256                               arm64_sonoma:  "ecc85ac05e826d4bfccd8ba8b3ead2d2db52e73bf55860e0f8f68168a61b0144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e733853350c4aeecce5489149636ef135698fbd9d5bc002aa44f51d6dcf5a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aee2533346f1d57dbbb078306723b03d12718a51f33ffb204b0a8965a4ba2cf2"
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

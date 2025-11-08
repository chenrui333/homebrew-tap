class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.36.tgz"
  sha256 "42095aacc8e39d8b7d5c0162fb44d873a1cc39430681269bac492c004cfd0e13"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "368c097c2c2990177f100b3be1eb7a06891ccb46debf13d5affa3e78a7e121f0"
    sha256 cellar: :any,                 arm64_sequoia: "1a3b020963e52f6cbf2cad1a6d44f5cab82f80b62e1afe290da55d8014d27c36"
    sha256 cellar: :any,                 arm64_sonoma:  "1a3b020963e52f6cbf2cad1a6d44f5cab82f80b62e1afe290da55d8014d27c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa0895fbac5082e6f016ab0991ff33760a943cb1d7608859621975a221e0571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd24172cfc4a0f89044ca4474d05e669a6edceada4e1012e906200ddb56f62b"
  end

  depends_on "node"
  depends_on "pcre2"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built libraries
    # https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md?plain=1#L79 (since 1.0.84)
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_vendor_dir = libexec/"lib/node_modules/@anthropic-ai/claude-code/vendor/ripgrep"
    ripgrep_vendor_dir.children
                      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version")

    output = shell_output("#{bin}/claude config list", 1)
    assert_match "Invalid API key · Please run /login", output
  end
end

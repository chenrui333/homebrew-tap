class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.14.tgz"
  sha256 "7e00d2282adab8e5db80f73e166c055f7468f021b1c16d09922d30673e778298"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9449f5efbb2d2cfee320f56b0ace36cb867e968eb04a657e0a74f00c5e81bb8b"
    sha256 cellar: :any,                 arm64_sequoia: "85d095ebe0aa0d04fa3bdd789f572156aaece9b9ae6821620a4c818e1d8756b5"
    sha256 cellar: :any,                 arm64_sonoma:  "85d095ebe0aa0d04fa3bdd789f572156aaece9b9ae6821620a4c818e1d8756b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64fc124550875599d2eae7a55ac73813a864d3c7adc5ebbda4d5bfc9db64675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acdb5e3990ad504c1352722ae2e1971760e863e510da64650379a69ad922ae5"
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

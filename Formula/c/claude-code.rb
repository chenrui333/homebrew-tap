class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.70.tgz"
  sha256 "70dd72b6295bea8e885050371fb965ca89ee860b252c7c7edfd971ed54c9f151"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e47ac63a4949aec32b01fc400451e21604a53f6ae03911bd455d93c388a281eb"
    sha256 cellar: :any,                 arm64_sequoia: "8b1ab80b4b75ba3781e65880416c1f80ebf2b9377ddf937e15f889de30d9bc57"
    sha256 cellar: :any,                 arm64_sonoma:  "8b1ab80b4b75ba3781e65880416c1f80ebf2b9377ddf937e15f889de30d9bc57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc0004d7703b0a809b5e67c5d079027d113a3a118121b150008361e8421f70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a594cf53f66243c3013be3f1e22374050a7f2ebb7438e6239415abb369a0e9"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.61.tgz"
  sha256 "e6e82124704b9ae30dc5f159b2fb4453eeee4d117948a1b24f59945a8eff3b9a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b2d40a7a0fd786c11b1bf7322542c42faf103c86d802697855ab1e3afd522ac3"
    sha256 cellar: :any,                 arm64_sequoia: "ad121162d056d76114a946a09f53f150f53a03f56415ec592dcf25107423246f"
    sha256 cellar: :any,                 arm64_sonoma:  "ad121162d056d76114a946a09f53f150f53a03f56415ec592dcf25107423246f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908d128f8f179914d152db187f062efa83bc6b4066f7ba871723a89540361e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e84b35fc83d3c463b690b6451f88e7c8388dbe71af9a0b30e033e43efd3863"
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

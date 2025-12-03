class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.57.tgz"
  sha256 "3ff2f935f1e436f0a848ebdaad2776ca0bab0c1e7b941656ce3a6e64d0b74043"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "69f44a92c7ee1b53e6d165d13ad523de07cd19615210133666b24d1cc00f9d87"
    sha256 cellar: :any,                 arm64_sequoia: "bca6a95f5356f9372dbc845a694de6ecce1908b991c1674f622a804f7e5c4d30"
    sha256 cellar: :any,                 arm64_sonoma:  "bca6a95f5356f9372dbc845a694de6ecce1908b991c1674f622a804f7e5c4d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3276111dba8fd7cef1a87ccb14e4dd909d1c969e538ec7cd06ccc6885ebf885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ad2fba397e3ac0b609a0a4e90ea87f94b495a91c041a2ae5bbbf409e3b9bb8"
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

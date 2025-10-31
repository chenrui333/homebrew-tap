class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.30.tgz"
  sha256 "43a82345af7eaae30e71df646e54717800e5109fa8334bcd1d194a5eb768b734"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "dcf37f063093e21bd5e3ce0b83c93ddbc4befa491f65999ce5ac740ec60b51e9"
    sha256 cellar: :any,                 arm64_sequoia: "615124c48af0b87985fd6c8602e712fa46c555b3f24340432af82438f729a3fb"
    sha256 cellar: :any,                 arm64_sonoma:  "615124c48af0b87985fd6c8602e712fa46c555b3f24340432af82438f729a3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18330abf7d394346c2a32ec83fc5b432f5498755751c3afc0fe56bb5eab637f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4dda139623d299da121e90d06d92c6bf403996bc6dfdd3ac824d8c02143d88"
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

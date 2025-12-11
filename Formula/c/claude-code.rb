class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.65.tgz"
  sha256 "b773c30a18b25bf30397af7b32075ed6a4be14227a6c2c1ce16329be5e45de0a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "195080ce9f45ebbdb4ae3e34889bd4860e61f359053f537eab10d8b1ec06ad03"
    sha256 cellar: :any,                 arm64_sequoia: "b2e24a34d4610fd8177bb7ca261416ef685708c2a263e1852fb7876cd4b1ebd6"
    sha256 cellar: :any,                 arm64_sonoma:  "b2e24a34d4610fd8177bb7ca261416ef685708c2a263e1852fb7876cd4b1ebd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0a9769ef810edf85a0cdb74a523fe7ec04ca7a7deb199347ed264f98d513faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0021bae61efb88f107fb5669625a75b7a806b737443953840bbcba208dcd21d"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.53.tgz"
  sha256 "f366f0bf1e6f7cbf4ed71e4048cc32806c17796e07a03da4e203e919a0f1eb67"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "dfec2ebf6259686899f91789e807bd1304778f72020f05bdc588ee35b9072455"
    sha256 cellar: :any,                 arm64_sequoia: "5a426728eaaba20ddb2058416f6ca0deb11c0e9fc33630620b67d01e00cd6c97"
    sha256 cellar: :any,                 arm64_sonoma:  "5a426728eaaba20ddb2058416f6ca0deb11c0e9fc33630620b67d01e00cd6c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "890c15d6b7316e71cf31f0bc0b1bebb74dd42e371a9e4a3bbf579593b0bb33f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0568a73c47cfe7135a744bae4276651a1b5a43516e62cc3da260cb5e4ff171"
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

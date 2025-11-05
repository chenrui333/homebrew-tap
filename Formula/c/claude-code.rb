class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.33.tgz"
  sha256 "53b8851e61a3bc7f8b39fd8dbaf0e54e6e61f2dc9289fa793742ef0d43d79726"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3709c5c9b4e64b6f568f7ced4b37ce481492bf469dba0adb9b45f24d78ed4a0e"
    sha256 cellar: :any,                 arm64_sequoia: "2edf57b7c9648b3a7423119851ca88515141d9ff8e70d4894f9c9a512ddd0d56"
    sha256 cellar: :any,                 arm64_sonoma:  "2edf57b7c9648b3a7423119851ca88515141d9ff8e70d4894f9c9a512ddd0d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e926a96cab902aac69c1586c2bf3a202cc1dc270461040972665e1c0613612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd94f1be8d28f330e847f978acdc65d4493d8b3afb9f24d351453a64a0f7754"
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

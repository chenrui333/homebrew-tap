class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.15.tgz"
  sha256 "e81dead19d805ea0fc502bee0a3cb1f742f162b8d90e07daef2ea1b4189ca8be"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5bf398d5618cbbb2e4c4b16a614a18d2cd31dfac7c14caf998d7539fb6935413"
    sha256 cellar: :any,                 arm64_sequoia: "df7010935e72d049838a033011ce466575d4ecf1b7e68bff09e4af12224a00c9"
    sha256 cellar: :any,                 arm64_sonoma:  "df7010935e72d049838a033011ce466575d4ecf1b7e68bff09e4af12224a00c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835d33a06f2b23e76030f8a91ff832eacaa583001149166d9d343f5718895530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2e52744c4e295dcd8573c6d43232967e45c366f7330fcb0978e58129996fd3"
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

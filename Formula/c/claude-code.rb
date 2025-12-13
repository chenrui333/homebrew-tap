class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.69.tgz"
  sha256 "6c929cd2491c819bbf9269e9fef9a083fafaf9db411f822e4f66bcb5129b2f33"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b4bdb7b08969d68df9bee6e59379b3ab172c15b35324b3660a4689645dda2c43"
    sha256 cellar: :any,                 arm64_sequoia: "54046b4ff488f7fd626dd43a0fe36772c8df225b0605ce2657687be426d70d56"
    sha256 cellar: :any,                 arm64_sonoma:  "54046b4ff488f7fd626dd43a0fe36772c8df225b0605ce2657687be426d70d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6b0268197ecb541f7b7f418c0d69e4ff0b514644be3c9d49c3df421c5d7d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "979b365395593a95ebb8486aeeb3f85c17689379b79b60d2ca2ff37584533404"
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

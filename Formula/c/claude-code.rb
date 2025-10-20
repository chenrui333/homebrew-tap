class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.24.tgz"
  sha256 "73fdf91d4f480565d4881907d146b97a77d5eb2b400990d4aa5e9b9fa36e28b4"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4bf25401738d5d9e1670cafa4c1740600eabb6901c2a8da52ce5f7d98ef0fb34"
    sha256 cellar: :any,                 arm64_sequoia: "1e09aab3a947fb6e3c7ebcd9997e024ccb9c754d37c3dfcbad33e6b78f37a857"
    sha256 cellar: :any,                 arm64_sonoma:  "1e09aab3a947fb6e3c7ebcd9997e024ccb9c754d37c3dfcbad33e6b78f37a857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ffe3735cd8c40975e27219881a7e99648210f1f51782a92d1ec2dbaced2fedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2211248a8803438c16548700a50a238ec9c79cd9e5254a31268b3aadf779c8"
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

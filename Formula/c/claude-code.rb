class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.3.tgz"
  sha256 "6361675e3eaf0480cc544b8fbdb6cc5f88b0b16f274231f0fb9322b70e890cc8"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2c742da96c4fac15a655cd3c922928e4019df405eaa6a95ab9102275e88d6b85"
    sha256 cellar: :any,                 arm64_sequoia: "fd5c6eaff9d0e67372d6c8604684b561b2eb0dafd60dc33cd54d873eb4468c2f"
    sha256 cellar: :any,                 arm64_sonoma:  "fd5c6eaff9d0e67372d6c8604684b561b2eb0dafd60dc33cd54d873eb4468c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f8e125de769a66b0be5d96f74a2ec00538394335ba16ed53e3c8e888fb0fe81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61422c51f9958153f3f1c828ce140b04c6ccf4947b1f7c5d32d64252a86ff725"
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

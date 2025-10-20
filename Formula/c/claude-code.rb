class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.24.tgz"
  sha256 "73fdf91d4f480565d4881907d146b97a77d5eb2b400990d4aa5e9b9fa36e28b4"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "13e389b27fd268ce46d5d2b560ae2430e48d0769e15a640c8ce66ad5427e4f93"
    sha256 cellar: :any,                 arm64_sequoia: "bbd0434348023fa852b5ca4105164858480215f72ce781d2badd8ff8c02df2a2"
    sha256 cellar: :any,                 arm64_sonoma:  "bbd0434348023fa852b5ca4105164858480215f72ce781d2badd8ff8c02df2a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b01e08cd5e3febdbe3adc2a6b611189e255c096f2e217b0f6f1ff3034a55455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e28fdb5884469aef3faa4f3bd022dd09c7f09e52d672908751a9368e510a1a"
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

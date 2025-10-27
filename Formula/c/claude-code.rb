class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.28.tgz"
  sha256 "572a925a5ef7c16fbff377ade895c1a69dae4d45bd24b9d9a589a7e1c9ff750c"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "79a6310db9551c024bde689b85c54ac17ae046eec9470c1239cc023e8af625eb"
    sha256 cellar: :any,                 arm64_sequoia: "fff913861527e26c781f496909f24fdad471e9e1992499bf02ca6f9fcf5a568d"
    sha256 cellar: :any,                 arm64_sonoma:  "fff913861527e26c781f496909f24fdad471e9e1992499bf02ca6f9fcf5a568d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d1f34ad160be70db5f4c24f2269af5211149b200c26a8e23a4077d44b59b26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd5bbf0635ddd5dbad1d2b21d9fc4e1aaca0559b534fb127b6d73aa691c162e4"
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

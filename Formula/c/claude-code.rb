class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.62.tgz"
  sha256 "73654d350071925a64688f65bb633f96e0c3802b5bfcbcde95062388af13d91c"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8f74430bb944b97e072ea87181df27e019207a65b3b2d4f9337eb25efd43d61d"
    sha256 cellar: :any,                 arm64_sequoia: "60c3f3294347c800f51062ce9c4104dd04f1d6b4c42a1c2d791419a4b875e30c"
    sha256 cellar: :any,                 arm64_sonoma:  "60c3f3294347c800f51062ce9c4104dd04f1d6b4c42a1c2d791419a4b875e30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d926f29f5cd61cf50b99a3281906ff15b232fb50c8e79b3c87e45bb8ccd3b59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2aacb700c3d5f7b31a020f66fb7ef0611543f105c80469cc602c9d61a9b6a8"
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

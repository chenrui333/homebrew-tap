class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.19.tgz"
  sha256 "f2725673be2456f47316be8a4876e2bf9981ead6fedbd3c9d68f7092d7b2a4ac"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bda96e5170b99b90dc7524dec39502567585401467b29118e813729637f69ce1"
    sha256 cellar: :any,                 arm64_sequoia: "f95e184e39818171fd8fb76b51b22109601595b1b660f42205ff6bec0537e7b4"
    sha256 cellar: :any,                 arm64_sonoma:  "f95e184e39818171fd8fb76b51b22109601595b1b660f42205ff6bec0537e7b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c2c1bb61ae51e62480b32f988c907914912add095a344a8b71bec6ed6dcc1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c15acd64f4be6cd982555e79c161e0576288b7342d3fbeb9b540c761c2b8c35"
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

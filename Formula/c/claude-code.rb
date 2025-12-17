class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.72.tgz"
  sha256 "31e0e7c1ef7cf3dd334aa46faaa78fcebcd88ab2ab2cd984d8fdb02fd97168ad"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "27a6f455aa58ea343e73bf1d5aa52305233ed4dbbc7cc18c51bd0aa7028dd110"
    sha256 cellar: :any,                 arm64_sequoia: "9e94f9c6a9e1be1f0ac126c0babeb06ed68eb201392f89d64ccf27e6663e1458"
    sha256 cellar: :any,                 arm64_sonoma:  "9e94f9c6a9e1be1f0ac126c0babeb06ed68eb201392f89d64ccf27e6663e1458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607ed049638223ea5a9e15b95eabd014f8fdb17a3ff29b0043315e6c62351042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d07e317339cee3d7a4579aae10d031d0cdf7df3be80a594f646206cc0901ff"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.13.tgz"
  sha256 "7995ad888584d2957b67fea102dafeb38eade27baffddf94d8af4081fa638d21"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3ac1aaaa5e7801c85ae5e07e705786d7ab79f0fc65d18015c0d46182768ae552"
    sha256 cellar: :any,                 arm64_sequoia: "853d80054f9bd14bcb9c99adabaad8d6b85362b115ae0d14bca10a87ed0fc5b7"
    sha256 cellar: :any,                 arm64_sonoma:  "853d80054f9bd14bcb9c99adabaad8d6b85362b115ae0d14bca10a87ed0fc5b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498748c44b9003e39ad88095fe5600e9cbe1da9e4310f726b4c7f84dfb1a586c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d739e02d9be43e733b061bb48f9e82609d786e41442be090451ac6bfcf988c87"
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

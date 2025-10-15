class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.17.tgz"
  sha256 "bbfd8a95311a63bf9ae024edc34f9ec31309bdf8ed390a1bda4462449e7649a9"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2ef6fc2270f78216491ec2748ffc8d22162615f838f6fceb295f82c477e9e6fa"
    sha256 cellar: :any,                 arm64_sequoia: "e9fd82a9a9fc860a67cd0cf10a366a355143a236c0e4a07f493d0cbe90678456"
    sha256 cellar: :any,                 arm64_sonoma:  "e9fd82a9a9fc860a67cd0cf10a366a355143a236c0e4a07f493d0cbe90678456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7086bc545d4eb7a7fc4d40deffa3d50ea1c1f2ab63a173479b02d2366bcb8db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a04d2a28a9ef8b3a1633588970223d57f5d1f35b78d06723d1bb75f67de1239"
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

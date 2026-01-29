class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.23.tgz"
  sha256 "77994350dd8bcb0ea679704563712232dffb04d2d5617ef14676cf3233e9c7b8"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "83c7e948554040ed425b06dda308882ad200ec196545eb6223d7b6146bae8fa6"
    sha256 cellar: :any,                 arm64_sequoia: "eb9ada4bd77141c06a92fbad3d7a0db2b750b4d573a5b89101c0bd33aa5aa4b9"
    sha256 cellar: :any,                 arm64_sonoma:  "eb9ada4bd77141c06a92fbad3d7a0db2b750b4d573a5b89101c0bd33aa5aa4b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f498545178b92503236338cacc12f24361d83e5bfa93b86e994508e9a8dafe20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8573b98542a47855a0b4843169977db603c0ceed0ac798e66b83bd04cab26efb"
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

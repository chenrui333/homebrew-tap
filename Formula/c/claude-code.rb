class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.53.tgz"
  sha256 "f366f0bf1e6f7cbf4ed71e4048cc32806c17796e07a03da4e203e919a0f1eb67"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e84768a9f6730933e92027a19ffdf25b7ce867972c07a2b344716502721dd6bf"
    sha256 cellar: :any,                 arm64_sequoia: "79df51db415a4a59ce36df93f6746dcf28d6c33edc5b1fdfbba8a27634b1b037"
    sha256 cellar: :any,                 arm64_sonoma:  "79df51db415a4a59ce36df93f6746dcf28d6c33edc5b1fdfbba8a27634b1b037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a0c4749ddcbe6362605775de4d6f72f4c6487412df398017c5ce1d92988194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd4b4b93b27e02544490ad15f00d40f56f0ebc6172580f11ae1a75c0f4c63b6a"
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

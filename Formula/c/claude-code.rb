class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.29.tgz"
  sha256 "ac93431031d7395e232686abec0838b7aa4747880a7b0c57be6ee38c5c2e7e07"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5bdbcd5ef1d4e550626028bd0756ef9b140013587383170c18a71251da239a79"
    sha256 cellar: :any,                 arm64_sequoia: "bc5b36eade43ff15ce9e145b57c9a58eb101475140b83aae3b5848d0d4763020"
    sha256 cellar: :any,                 arm64_sonoma:  "bc5b36eade43ff15ce9e145b57c9a58eb101475140b83aae3b5848d0d4763020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1b7d586c59720348c190c09572b7b0d617bd2b8ee34d6e8e3813da911b993e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9995c1e1df7ec396e5f82ab43db25c530ac123031b4347d7c738397050509246"
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

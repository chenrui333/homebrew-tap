class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.30.tgz"
  sha256 "43a82345af7eaae30e71df646e54717800e5109fa8334bcd1d194a5eb768b734"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd0f9e02741dbe04a854e948a1cd5c2e460e6f043c831fdc8791d4648a8afb48"
    sha256 cellar: :any,                 arm64_sequoia: "e9e884cf671e753a6b05e9c1df6cb9da294e64f6a6f299a0cd819a8e395fa348"
    sha256 cellar: :any,                 arm64_sonoma:  "e9e884cf671e753a6b05e9c1df6cb9da294e64f6a6f299a0cd819a8e395fa348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0538f90001c1bed37b4574e968d3f9cd0fc6f21d2623f2282a70980f41f1db4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd4c108e2c18ea98947dd4b66f9aeef11948757e75622161c673a06f680b8ef"
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

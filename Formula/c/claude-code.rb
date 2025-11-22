class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.50.tgz"
  sha256 "8914b1be7b6748b45324de7af7a0ab76ffc08d99d1b51fae2fcefaa17d213ccd"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e7f4205c948e7bfc8e332a2fe2a12cb3696ed8e7b84e860908dbd8e6e42cc029"
    sha256 cellar: :any,                 arm64_sequoia: "be214ae363428b97eb3e4c937f60733f463aae3070393f12e700ac22f9d323de"
    sha256 cellar: :any,                 arm64_sonoma:  "be214ae363428b97eb3e4c937f60733f463aae3070393f12e700ac22f9d323de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981d4f62de74ee32cf3e15898ef51e4bde14a2cae475db4fd011c1ecafb29efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca53d9cda7994b664045338f4e0dd32ca0b3cee3b0689dd51d77695dcb479f2"
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

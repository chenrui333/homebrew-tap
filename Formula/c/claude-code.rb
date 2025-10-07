class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.10.tgz"
  sha256 "6da2b11dba8b0c7f9f2a5e2a97516c437de4984f22296fae881690f8f7d56419"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "868d77459f63415b2435c5309d36aee74096d598d273ff69723ddb53c9ad1fde"
    sha256 cellar: :any,                 arm64_sequoia: "f0c010881dafa8b30a483a7e2517cceec33baae0406d5528412b813d0d13e5a5"
    sha256 cellar: :any,                 arm64_sonoma:  "b2233ba31ca2ebc93c89176d462b5b68d8cff69607c80ab78fbfcf3c7ef073cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55aa506cb2ef4dd40bbe906615a0fcc9b60714dece16ddd4a0c16aa477fb0faf"
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

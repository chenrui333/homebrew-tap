class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.7.tgz"
  sha256 "89a7c79e54246d86e7cc9188fbf2552a70f3695144fd14defabf80f8c81ed874"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "755ce1defb7c0a0fac4e6bf8d38cce52cda67da350cd313d08c95d210f2c4321"
    sha256 cellar: :any,                 arm64_sequoia: "c49fd9bf449a8b9e077911411b1707e1638da081d280c95c5ea919c429dfa73c"
    sha256 cellar: :any,                 arm64_sonoma:  "c49fd9bf449a8b9e077911411b1707e1638da081d280c95c5ea919c429dfa73c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674ef88e6ece6615ea87e20fd86c80fd9c28352d726db456272a7d52d2a76b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a730abf589839596e28b81ed9dd07be714bc02e7a3b7515903a5bd62713cb6e"
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

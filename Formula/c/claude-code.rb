class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.14.tgz"
  sha256 "38a101cc7b71ba246d951b886bf05ba3949ad3fefb0c98cd0b0d44930e2d7219"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "feb95107ff0c343b3d51b323b86bab84dc4b84b34311e20abcd409c0cee1d0ab"
    sha256 cellar: :any,                 arm64_sequoia: "d6ffb7d83b933a0a3368b3d9ea305dbc9aaa3f3df82dc7c273e7dcf985a5b359"
    sha256 cellar: :any,                 arm64_sonoma:  "d6ffb7d83b933a0a3368b3d9ea305dbc9aaa3f3df82dc7c273e7dcf985a5b359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed3b6ad8077325a21128db411b9b185681b3f6b612935be37a32f0f03fc1235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57785a8d270f644fb59b4d3a5a3b32a83bde1aeeb9a6a4e1091cfc578d362d0"
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

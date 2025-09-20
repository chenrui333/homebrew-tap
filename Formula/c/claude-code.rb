class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.120.tgz"
  sha256 "b3e7f924260818370cec9e0704da5b6faae304f9e8c2a06f10ce032a662937be"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "6c31a1842166e8725595c1e72fddfcff8ef1e1dc77179c5046f64b39c9c18252"
    sha256 cellar: :any,                 arm64_sonoma:  "3c9fde17e999b7a612fca5662f66828f562109524fec145370f268a74511f2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11a06f101500b27e4552886107dc0bdc8b93863c4e33d84331a7177efdb7027"
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

    output = shell_output("#{bin}/claude config list")
    assert_equal false, JSON.parse(output)["hasTrustDialogAccepted"]
  end
end

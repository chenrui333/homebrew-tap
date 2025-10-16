class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.20.tgz"
  sha256 "345eae3fe4c682df3d8876141f32035bb2898263ce5a406e76e1d74ccb13f601"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "aed98e5129a3781c74db3c204c72dbebe2c20328ddf7392fbdd32d8e0d8de6a2"
    sha256 cellar: :any,                 arm64_sequoia: "d8356e19097955cfe97810546a38c19b8d243e4c09af9ba265832ca931763806"
    sha256 cellar: :any,                 arm64_sonoma:  "d8356e19097955cfe97810546a38c19b8d243e4c09af9ba265832ca931763806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210f18865079c9755f50cca317cb0a5b33ebf801bbbb4b299c5378866a51cae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963d9db189fd4dbffda48f480b4f33e61f74af92f5366b347ae2c948740b22b2"
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

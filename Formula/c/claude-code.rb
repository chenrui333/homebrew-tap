class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.16.tgz"
  sha256 "944874a39eded5b48350aa26eb4871c55d956549e01135c1bddbdcea0b840992"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "28313fe8556ae340b9c3bbe6c084b622e00063287c237222236c620d56e4ed02"
    sha256 cellar: :any,                 arm64_sequoia: "35b63fd2028e7dbe47670b3aee8a2179c9125a0f5619634f2cf502670b056c52"
    sha256 cellar: :any,                 arm64_sonoma:  "35b63fd2028e7dbe47670b3aee8a2179c9125a0f5619634f2cf502670b056c52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca34db1c4286044dd28b6f23e2cad3d0455b3b2ba87fd1437fbdd17f56b88521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121decc43571a2aacab97c0040d247f5fca968386a51c9090d73ba8d4cdf4442"
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

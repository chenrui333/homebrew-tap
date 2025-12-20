class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.75.tgz"
  sha256 "810cdff8b1bfc1d21db164887cd912ae4f8d41823d21364a02cd1478d13b8362"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8ee4b7804c4f86d1b3f1c21e085f78a31482019b29929a3a14c85150bc238255"
    sha256 cellar: :any,                 arm64_sequoia: "c30d4b19b0c65aa677b46f29a2a22669fe822928472ce6af0db15aac36dd0126"
    sha256 cellar: :any,                 arm64_sonoma:  "c30d4b19b0c65aa677b46f29a2a22669fe822928472ce6af0db15aac36dd0126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b674402bcaa018345b1c99fa593782ae6fa2853bb69f87e7f7b2aa45987f7b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469ed78510012fc395f0071eb2b1003cf23a3c006ee88e5e4815ba74ee6cd2cb"
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

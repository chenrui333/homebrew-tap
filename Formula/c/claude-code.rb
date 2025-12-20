class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.75.tgz"
  sha256 "810cdff8b1bfc1d21db164887cd912ae4f8d41823d21364a02cd1478d13b8362"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2d7482f81e65971c61837a0649afe7986be56ee3650f9ea29fdbe41d02c52194"
    sha256 cellar: :any,                 arm64_sequoia: "3dea908631cef33fbbd630cec4a398d2e33f05770200b14c0c11869fbe383001"
    sha256 cellar: :any,                 arm64_sonoma:  "3dea908631cef33fbbd630cec4a398d2e33f05770200b14c0c11869fbe383001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bddf3853ee730804a697279acf27f56223e156b1a1c8412dce718d3bb8ef5907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4dc6a2bfc86bc2d652831ddceda9dc631373f1ec0096231d985608d0f4ff5d7"
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

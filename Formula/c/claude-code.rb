class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.0.tgz"
  sha256 "6c39d191419ddd73050a056bf26dc165a713f82d3f49c6f2bb78fa92941650e3"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "cc136a4f2b577b496af9f7241963e9d89109afb358d75c1dd845270a6f10fe2a"
    sha256 cellar: :any,                 arm64_sonoma:  "f972f8de59b2a126538a0839448bfb93c9d15c4271a3f31b217b8776149b792e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31484bac7bdd78e65fc3c5c4d330b455cf3abdfc192fae3d6a1ab594b8aa4f47"
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

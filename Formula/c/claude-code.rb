class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.42.tgz"
  sha256 "ed56cf3bb1020bac9440ba691d27b6e8b94c3905fe352fb94726b3e9c588955a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "89a488f0f6c4c608e9a1710bbcf4cd22737a330c3e3a772aadbfb15c6e2767d8"
    sha256 cellar: :any,                 arm64_sequoia: "3471e2ea6d4b7949fa1f7dd1087e683ae95a810191aaf50c1d7c83ae1f83823f"
    sha256 cellar: :any,                 arm64_sonoma:  "3471e2ea6d4b7949fa1f7dd1087e683ae95a810191aaf50c1d7c83ae1f83823f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd08a3036312d272af19e2d01da907f6c44061771d6196ac70038c660c12959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb5e096ede4bd5874e1d91dba0baceaecfb8c7d4cf81fb45d6785bcd64631e3"
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

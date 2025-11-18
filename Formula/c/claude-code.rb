class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.44.tgz"
  sha256 "952ea0f02662b0be6d65d3c869a569810a7caa2e44ef99913ae881ad7792d640"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7c3d8cac0d27129232319dc11d300cd9b71bc58c63f350a29a5182008a520bd4"
    sha256 cellar: :any,                 arm64_sequoia: "1f34cfbba8e8346249d54f446a5df8fd463cb058539fa600cd00c158bbcdf8be"
    sha256 cellar: :any,                 arm64_sonoma:  "1f34cfbba8e8346249d54f446a5df8fd463cb058539fa600cd00c158bbcdf8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5087ef1c271e471d6f3d1058b59c2d79e704c4a3bb700f605249e5812e02f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f96b8fc96c87f00bf0cae5a30023b0fbd18d41b40b4bfaa70a2acc5f2e86998"
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

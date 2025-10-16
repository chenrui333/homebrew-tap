class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.20.tgz"
  sha256 "345eae3fe4c682df3d8876141f32035bb2898263ce5a406e76e1d74ccb13f601"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3b1068b88c44cdb846cee7941d6168f9697021747d28d3494ae0e9b3834b2fb9"
    sha256 cellar: :any,                 arm64_sequoia: "b037f0b0df57725b245688999d001a582845c9c8cfbe3ae72ac18ea7e5376b5d"
    sha256 cellar: :any,                 arm64_sonoma:  "b037f0b0df57725b245688999d001a582845c9c8cfbe3ae72ac18ea7e5376b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d318ac5e7dddc0857295723d1dff9b933ba32ec4c891c948506b045619f19f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9606c8fa88035357a8256de5eb543e3c7c218d39c6e9ee38b669a9b52f7f9817"
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

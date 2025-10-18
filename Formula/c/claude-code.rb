class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.22.tgz"
  sha256 "8afd39d9129d0d93ead23749a42db52763394fc8b2119dc094c168e8de7ff851"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e77e391f147ca85caf952ef50d9e5e22580dd715fc047e1938ad8bf43ca8f876"
    sha256 cellar: :any,                 arm64_sequoia: "356a5108a9783ef159e47ad9052ed2198be330bb1a0efe832f4eca6699163969"
    sha256 cellar: :any,                 arm64_sonoma:  "356a5108a9783ef159e47ad9052ed2198be330bb1a0efe832f4eca6699163969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189cf1b6febfd99ef3c3d0acff38bdfa6e9c40ebbdb07a28080d453197a21cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c46855591448c156d6f8bf9ec1959aed2d1a80928fbfba7a53c467c888aa441"
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

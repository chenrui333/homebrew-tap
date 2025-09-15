class Heyagent < Formula
  desc "Claude Code notifications"
  homepage "https://www.heyagent.dev/"
  url "https://registry.npmjs.org/heyagent/-/heyagent-0.0.4.tgz"
  sha256 "d3da7e5332789d1d46121fa79f175bfe7b06c73d2046573a3c7c49273869c378"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e81d43f4714b95b17aa76bca31d1a2d80a1535bff5ce9ad3976abe94ad6a66c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb85a4184a67280e4a656051ea1038c0ae333c9a447e88e93d7ee87653ab45cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236be051eb808f5d750e2b736766091817ca131bdc97f537e1d667efde76a3fe"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/heyagent/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hey --version")
    assert_match "HeyAgent notifications enabled", shell_output("#{bin}/hey on")
  end
end

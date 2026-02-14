class Heyagent < Formula
  desc "Claude Code notifications"
  homepage "https://www.heyagent.dev/"
  url "https://registry.npmjs.org/heyagent/-/heyagent-0.1.0.tgz"
  sha256 "9725d5ff38c390e72d107d19ba16c492a6a57ea386d5e68fe951625301aef04a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c1ab94ece877f47090fdbbdc55e7233681ba6e60717fe29f3c7b59939c5078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d69d16c67197f6bbf4e9ed1aa4417123c424a67eed4a962305bb67eaa31ac52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d70970980581b8b511e3e2262333ba304d854f7a0dfd96443ffd19ceffe889"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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

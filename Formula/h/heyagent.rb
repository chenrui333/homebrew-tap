class Heyagent < Formula
  desc "Claude Code notifications"
  homepage "https://www.heyagent.dev/"
  url "https://registry.npmjs.org/heyagent/-/heyagent-2.0.0.tgz"
  sha256 "5bf3f3db28e218a835ee6b22bd22ab2b118f36324a40a4d5839c3dd7cd2b9e79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89eb11619a8c5c77c1db80b8fc75083eb4b0fbddc7e002903bdba33b4f3bec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89eb11619a8c5c77c1db80b8fc75083eb4b0fbddc7e002903bdba33b4f3bec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89eb11619a8c5c77c1db80b8fc75083eb4b0fbddc7e002903bdba33b4f3bec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f3950bca7c2d9716b86dc8bba7606314957b6b4a7d81fe7978761b76b3bfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f3950bca7c2d9716b86dc8bba7606314957b6b4a7d81fe7978761b76b3bfd6"
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
    rm_r(node_notifier_vendor_dir) if node_notifier_vendor_dir.exist?

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
    assert_match "Provider: not set", shell_output("#{bin}/hey status")
  end
end

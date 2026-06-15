# NOTE, the project has graduated.
# https://github.com/possibilities/claude-composer/blob/main/readme.md?plain=1#L4
class ClaudeComposer < Formula
  desc "Tool that adds small enhancements to Claude Code"
  homepage "https://github.com/possibilities/claude-composer"
  url "https://registry.npmjs.org/claude-composer/-/claude-composer-0.1.14.tgz"
  sha256 "28d47fcb686f44258eb2acbee56bc996799d8b8d457189084502f197dd0d486d"
  license "Unlicense"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cf6aa6019f798c2c23ffad27a99cceea03e0175ecf0b966e534031379a7014bb"
    sha256               arm64_sequoia: "8000fe403feb16181669e5f1e418ac2aaff1b8e30bee8157c54b9592d8d80b26"
    sha256               arm64_sonoma:  "def65288849958ea56fe21a8c011c1db619dabbf4eaff5512d512a6995f1ef02"
    sha256 cellar: :any, arm64_linux:   "64f4234ec6d327e58d36994d63f9e461926f23470908957d47c1db4bdc32aa68"
    sha256 cellar: :any, x86_64_linux:  "393dfec1844ac2f9f9d44a3d4f202461bdb8337d027aee791dc2c05509d16c71"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    ENV["npm_config_build_from_source"] = "true"

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/claude-composer/node_modules"
    node_pty_prebuilds = node_modules/"@homebridge/node-pty-prebuilt-multiarch/prebuilds"
    system "npm", "rebuild", "@homebridge/node-pty-prebuilt-multiarch", "--build-from-source",
           "--prefix", libexec/"lib/node_modules/claude-composer"
    node_pty_prebuilds.glob("linux-*/node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # use `xsel` from Homebrew on Linux
    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    # FIXME: Upstream's version path requires a TTY and shells out to claude;
    # replace this with a version assertion when non-interactive output is available.

    if OS.mac?
      output = shell_output("#{bin}/claude-composer cc-init --use-yolo --use-core-toolset 2>&1")
      assert_match "Created configuration file", output
      assert_match "Core toolset enabled", output
      assert_path_exists testpath/".claude-composer/config.yaml"
    else
      output = shell_output("#{bin}/claude-composer cc-init --use-yolo --use-core-toolset 2>&1", 1)
      assert_match "PIPED INPUT NOT SUPPORTED", output
      assert_match "positional argument", output
    end
  end
end

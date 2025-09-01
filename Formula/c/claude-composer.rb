# NOTE, the project has graduated.
# https://github.com/possibilities/claude-composer/blob/main/readme.md?plain=1#L4
class ClaudeComposer < Formula
  desc "Tool that adds small enhancements to Claude Code"
  homepage "https://github.com/possibilities/claude-composer"
  url "https://registry.npmjs.org/claude-composer/-/claude-composer-0.1.14.tgz"
  sha256 "28d47fcb686f44258eb2acbee56bc996799d8b8d457189084502f197dd0d486d"
  license "Unlicense"

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/claude-composer/node_modules"
    node_pty_prebuilds = node_modules/"@homebridge/node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
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
    assert_match version.to_s, shell_output("#{bin}/claude-composer --version 2>&1", 1)

    output = shell_output("#{bin}/claude-composer cc-init --use-yolo --use-core-toolset 2>&1")
    assert_match "YOLO mode enabled - all prompts will be automatically accepted", output
    assert_match "✓ Core toolset enabled", output
    assert_path_exists testpath/".claude-composer/config.yaml"
  end
end

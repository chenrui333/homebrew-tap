class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.14.tgz"
  sha256 "7d715c3dc611e3134aaa96a1f68467471b2c50c9b04fba093f4bc4b2ad17b599"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b7d7d2b73aabdf231e3439587349c4855997c526ce648d17c69baa7ba225aaa5"
    sha256                               arm64_sequoia: "bf24d2200c1c1e7b359c4b6e67947dfac3daae59e87e24b69a51c7a11938233e"
    sha256                               arm64_sonoma:  "dcc8b7bbcbad8cde3004029c5f8034b92c2cbd61c7fc170d06ef14db93dc1c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7d42935b99cbf27e8680ccb96d7f7676445c63c9ded81affe45f7ac2fed4f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647e210795a6fa1aa95fadd5ee608f3e729261a720c5cf03cb46a79c4b91d32b"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    ripgrep_vendor_dir = libexec/"lib/node_modules/@iflow-ai/iflow-cli/vendors/ripgrep"
    rm_r(ripgrep_vendor_dir)

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/@iflow-ai/iflow-cli/node_modules/node-notifier/vendor"
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
    assert_match version.to_s, shell_output("#{bin}/iflow --version")
    assert_match "No local commands found", shell_output("#{bin}/iflow commands list")
  end
end

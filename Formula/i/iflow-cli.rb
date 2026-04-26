class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.19.tgz"
  sha256 "4ac4ec1d6e52362c5794bb07213886bafb554d4036752b8af8c8ca08462ab365"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0ca6bc04772b3fae4bbae453e3e5f43b37dc589a0d241791983d654fa3c94e80"
    sha256                               arm64_sequoia: "d0567070d2b3e524af4984d7b8536aa6645c4a3c3b87732bf0e0059ce7fa6414"
    sha256                               arm64_sonoma:  "da11732037439574092b180a52c14e2775dff5e8f88e6975c3ab9a1138c7d806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f93fac9f67127398fb6871e2fe74e12f0d45a97681f11d9f5b1d6c930817760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabea75bf717940c5b88315d67f3547dbce67cea6f490b426401114202fe18d9"
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

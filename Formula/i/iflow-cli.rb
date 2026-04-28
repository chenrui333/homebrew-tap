class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.18.tgz"
  sha256 "0ba6d9d7a1e0ee99facc26fad6324d65487dc792a3490838a061a7a8c8326a55"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "993f6eb393694ad28f7900f71cad08f40d8d6c1bf47583318e98131dd95c0ddd"
    sha256                               arm64_sequoia: "584206e871dc820a09ae46ac5e7cc6bf5806cfd66b7b631f53d112927a930761"
    sha256                               arm64_sonoma:  "1b09907e3c7e7dc8df418eea5636d891f782f57c795f9555214c552b47f1b1da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8ca734d16aacf669f91919f334a3693f932d321b26f68320b2a7ae1671b2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215138879d1806bb51e2ee071569d4e8d1394d9c269fb9db17ee17aa43031591"
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

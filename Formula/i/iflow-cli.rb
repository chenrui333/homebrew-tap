class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.12.tgz"
  sha256 "5a6f055b1add053bb645effdcabdb09ced4b084b7fabe60c381d00c555d4d951"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "2d03c35e262030f671cbf83c5ee4c91fc6e6a384330b0f38a9b0415a3f8bfff8"
    sha256                               arm64_sequoia: "805d593915c20d2ae61f8755642cc140157644da9b670aafdc1ffdde1af3df26"
    sha256                               arm64_sonoma:  "1c4edeb1a3c97e864bd7a801edc0ca39290601f10993211827ca896d0b284297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca46524153a7e5bb2b4a85b1f72e298de01058ef4ab715e193135033d62872df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e7dcc25c378837a8c4bee6fc1c2c9e8214085a51fb56af3aba03659b966568"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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

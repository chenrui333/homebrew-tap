class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.13.tgz"
  sha256 "cb20836899728afec257396d1e5824643c43e2a7001a1c6e72b9db9b7998bb77"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "62e187c2e03c37e8c9dd7fda931b3b387c971ba013820dfea563fe1625f6a97d"
    sha256                               arm64_sequoia: "35aa4d63710084b13ffe5104f6a9a66f88444ee613af927b1378c8aae233679a"
    sha256                               arm64_sonoma:  "cd869563e5058e23299edbaafc95b08671f2e70717e17cca85d22ca967b54d0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80208e9a98277919bcd411a5103b0358eb13ee78c14aea8244631e2f45b637b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ead1880cbc707c0ba24a596e28bd6c50a16134f13b6da6ae46654b9adbd9a7"
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

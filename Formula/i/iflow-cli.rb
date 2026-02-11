class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.11.tgz"
  sha256 "d84eb0d53603f55f79e31703f34318de5c297d497b155e2bafb4ece604e617e9"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7ef5ec6a1260da2d34ebfc859dc3a4f7003493eb3cd8363a504dec9a7d28060f"
    sha256                               arm64_sequoia: "c1a24054da5b663a20026f6b5cb9898db88c1a3a5bde3f3a9e2255939569148c"
    sha256                               arm64_sonoma:  "604c14a1f4f796158974d143bd301a2926a7686f0a8c8720251e272c5fb821eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35c402d9d99ba78b0ed5584741df7d3e272fdaaf42ad0bf4e5a130ae18498b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e490c56a31a5308b6f82d88e618c08017e587f700d27eb70d7823f871015eb0"
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

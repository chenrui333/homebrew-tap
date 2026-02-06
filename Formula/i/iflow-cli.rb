class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.7.tgz"
  sha256 "df9aa0cd6f25a64315e819c0abd95f4cc7e94f8929d20deea85aab8cee5dff01"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8da95f51d611d4c77c9d2a09f78967e03c2383795697ea2e37dd7030a81df9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b36ac399224109c912cd9998278d41f61f0cc76420c20e1203522ccd058eb8"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.10.tgz"
  sha256 "945d63633f46db7e0a12f05440ce7a91fbe0b4c7174803321360a0ec1a84dbcf"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "695cf3ad9087ce1031413dd9208b915fccfbc9202bcbca659545a4110b9f6a30"
    sha256                               arm64_sequoia: "2d5eab400866df51aedd6e561d4ef7d5ca6a16272396f14baa2388581d42ee6f"
    sha256                               arm64_sonoma:  "33dbfc1f856570e55d50b91baaba482fafe03854c17f8ac7da0178fe31e891fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b2417eda71584361bf38b2cd2137f313f684bd71216a1f612cd0ea87f3a7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc814fdf1a490aa800e1c4ab385268b83eee81a19f3b3bdf8257b44984d6d886"
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

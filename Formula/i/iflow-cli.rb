class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.16.tgz"
  sha256 "7ee51abb834fa6cf2cfc7fc124d59ccae89a6f413e4a8046295cbe7f8b0bfb59"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9a3aa8c6d57281e3baedc024e8cb36d89632abe8b45ab478622112cb9497dca5"
    sha256                               arm64_sequoia: "5c7cb352914bea4139bce7c90ea97e916657d7f282f6287b57bb5682ac443c20"
    sha256                               arm64_sonoma:  "486dfca8b9fcfa3adee5a6c6a9c75a0bd9e224d734c04330a46b59f66ff66bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5123dc1f41a937f9caec79a3290f68cdcfc3ec9173ec0f16c742001303824da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa0163b6be5b4a7bb88b1cf1aaa2e2fd33c146797cc20b23094b331e75cec58"
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

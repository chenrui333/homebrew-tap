class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.16.tgz"
  sha256 "7ee51abb834fa6cf2cfc7fc124d59ccae89a6f413e4a8046295cbe7f8b0bfb59"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "74ab116b21be7fdeb512b927aa8e1549771eda6f24ac9780cb040e1ea37ea770"
    sha256                               arm64_sequoia: "5a966ad935f70cf63606bca2b3efbec3746c9fa7d24ba672585bd9a203fbfc14"
    sha256                               arm64_sonoma:  "105fb0a22fd24c9843c3adca462504e539fcb0e25f592b27f53fceba0b5d10e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92aa8dfe697abbd35418453075ba2f73c98773df0eb2147def6e240b637ec264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ad9477d5f3f32694e56d9de7c3b533b109361c3fc4e7a190261ea9ab35608b"
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

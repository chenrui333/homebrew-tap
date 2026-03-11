class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.17.tgz"
  sha256 "b7c104c14a8b02558d972c22be52c1ed95e3e87b73c09bd6e7afd6d2c05d9b63"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "c4334381618a51a8cb50226fad90b23e74a518b8c935f1503796cece361fda56"
    sha256                               arm64_sequoia: "f8d219b5cfc31f68e9567bcfb313d6d5137e74ce9e76dd9d018aa118a0ee58d4"
    sha256                               arm64_sonoma:  "376dd39ee96be36825e660fa01026df76262e592babd6d2a50d1884f5b00eaf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "475961c0f104ccccf852d685e38288c42f2c0d941c2aa5cd822509973d561e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f8cefb0b83d3da20c116db3f838496733f89fd7acbef03a37c8df1119675857"
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

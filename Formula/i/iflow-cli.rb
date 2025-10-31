class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.13.tgz"
  sha256 "7ddb6a6e304df6ad306462a7b76bfcc064e9715fc701475443de2a9a9e7b62e4"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f14fac78911c22a43aa7ba202719efb951e6e497450699587ff63774d08f5a97"
    sha256                               arm64_sequoia: "d8b9cdaa0cc3561bb03d0e73ecc689d18bfb10823249ecd9a5cd74778f1dcf18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f110f5a54d2e95115952f6db13f8188f4db5e13918f7f85dfd34085717318f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b4fb24ce07ef1973dbd732b8b30674b5738b319b1003b9a11188df639802c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81375d16f4a3b063ced78ea53c595e95bd244feb7086e79afd00750250b42fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    ripgrep_vendor_dir = libexec/"lib/node_modules/@iflow-ai/iflow-cli/vendors/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iflow --version")
    assert_match "No local commands found", shell_output("#{bin}/iflow commands list")
  end
end

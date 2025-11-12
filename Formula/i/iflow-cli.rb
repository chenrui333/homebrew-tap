class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.20.tgz"
  sha256 "d3e7e4e9890431935ffda964c2cb47a0e6e9e78388de0b09a1d61dd14e1d76fd"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b98fa193dca89f80e3149e450ddc8f2e92bfe2a4b5f9075acda7b4437eba33c4"
    sha256                               arm64_sequoia: "6c792cf8f0aa4b815aa652cb6d7c242b2a42f9b57835f923ab794db15239bcb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8b7f99208e3d37764a9631360ff9d528eda47722905937d80752a1cbf30e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13d956865ee873f55fe3c03bd34461e63fd662f18f0ec9d2b03b6219147a26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6914e2709f1a0e989288df44ed8110359b79daf0ad6b6d07624e1572a70c3b"
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

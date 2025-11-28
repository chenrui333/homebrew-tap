class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.30.tgz"
  sha256 "e089bb7e6135658c9eff2f6cccdf21bd8cd06ef9967ce17975f539b4a1ccd436"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f407701c76114247624ca836ba0167b7287b9e732b86c181669d71f8f13f5e11"
    sha256                               arm64_sequoia: "da342092e8e24dea6f16efabc89dae8f3a2e46b7524ebba58393966781c37938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114c3a5622afc7bee2b896ab396b0eb3c000c9bd9e21968946bd4be31389ae11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79eb1432df3b1f94c15a91fec1efdae8fe38e3cc217d5efe59e18339541a6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e6e5f92321a60ac146d434a868049d270ad9146acacec5cad31763c66c7cba"
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

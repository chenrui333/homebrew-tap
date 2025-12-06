class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.4.tgz"
  sha256 "dad3433af87f366a41c178d8a7d6cbac2e4b160ec9d3de20fbf33ce8e6968bfc"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed8bf789d2a135aa89bc7e1fe14c408723b5a562dd4bf95e6cdaf8faa94a48e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8bf789d2a135aa89bc7e1fe14c408723b5a562dd4bf95e6cdaf8faa94a48e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8bf789d2a135aa89bc7e1fe14c408723b5a562dd4bf95e6cdaf8faa94a48e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ce77d26993b7963c2c0c481b39ee43324ead8200c2636487f0573c3073a454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6a3e9dfde30f57a6f890951b4ad15413a3ee00cf07b191955434256165fc85"
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

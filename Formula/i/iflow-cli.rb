class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.5.tgz"
  sha256 "5bb9d25b11bb0506c7a6fdc35100f2f3be2858a25cc7ea1eac06849f590fa42f"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c555feefc30a31f2c946da7a7fc46a9fd6b9b4e72d1ce6673c2e3f93593d3833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c555feefc30a31f2c946da7a7fc46a9fd6b9b4e72d1ce6673c2e3f93593d3833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c555feefc30a31f2c946da7a7fc46a9fd6b9b4e72d1ce6673c2e3f93593d3833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09975680a828f3e8bc0bbb13a8a182d23971ceed2c82651b781568cf2add9732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7fb38e5ee9debdce335a2d504c57b001943848de6a9931307b4f0cfd728df4"
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

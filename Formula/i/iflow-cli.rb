class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.26.tgz"
  sha256 "44f36a053167ff1f830b04dae5d7155b6080ebe8cbe82fc934331016c147d26f"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "64d13c481569b843e23600fbe8bff94286387d2e99f8d82ed9a0d72d90c28993"
    sha256                               arm64_sequoia: "03027610a0f25058857dcac1a7f889cc3d9433120cc4965ff4196d30b16215a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c81507df9236e6569b73d803d3bb2abba33c3bcc56ef4da05b60eaa91bde89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60347e82a98affe786dd7c8f4eaff8bc2e5753199f9033cb1ad9bac6f20b94af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdc07831d9503effc1e59cd8120655ed785b5a86ce133429326d8ac54af3d70"
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

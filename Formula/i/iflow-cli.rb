class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.6.tgz"
  sha256 "e2d48343c94eca25772e31f551121f348a8ec959b25d9110434a50ab473d8d3c"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6b4485e59b04b8a455c9e5fee1e8f5e4f11b46716280ead90df4e27259436d01"
    sha256                               arm64_sequoia: "3912b01d72efae08540ea6ad3b06d38b320e382f7121b596d0450f5f6cf768fe"
    sha256                               arm64_sonoma:  "0a8e127ec2ecd56acc918a48ccd73f51dcf12db928cbad4138133a086f36a189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f28a1b71d0b28207b4280815601dea35fb7cd4d27d16ee8c07316762379681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5bac34a788879c22b29747fcb24f35485c7037a2d680d588bb288e9f8c3963"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.13.tgz"
  sha256 "7ddb6a6e304df6ad306462a7b76bfcc064e9715fc701475443de2a9a9e7b62e4"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "80fffbc454a9e741c03cef3b5ec16a13a03840959341a19bc55923e433654efb"
    sha256                               arm64_sequoia: "a7cd56e32cc8f6e6434463e266df25623021b5d474796217f6f6d1e4190b938a"
    sha256                               arm64_sonoma:  "735d047539b99f6bd4577cd04201e7d657c24a998e06cba4ba58eef1d31eb6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245839a12a42102196f4ee4e097ccdf470349653e0f3cec2c48d8a52030109f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe252669a867fe839ed28bfa503051ca534eae0c21ef7a348207e1a767e98377"
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

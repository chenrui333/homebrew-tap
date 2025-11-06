class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.16.tgz"
  sha256 "a1f346bbde58ba1f1c519c230b339fa54f4d1b7c65ff9b1a5bc9b8f75d040555"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3ebaaf3bab9879b0ca6e198b0b2a294e551aa6339d2e870804c4f51d81d3cd02"
    sha256                               arm64_sequoia: "fb1969dd4d19747b0ac5aaf2e50eb4dad9d0730ff99adc0657be64e87de2e8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426694e54576128358f0a25e7d29d4041bdff3ba375407b727358a815221e942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44da068c3b053891e94a1b5d0798619f856a1dace13e84c3b83855f2fb07d111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474e953e501943ac6acfe3869682d2be08b46d151c379617e9fa653e916b6f9a"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.7.tgz"
  sha256 "6394060a441a2f4e35a8c91800cf6a678a6dbd656276a4314503342537fff9a3"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a3f2309939e9f16f9226a91ea86d2a340d85e8cdb54eb76c59b040bea17977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a3f2309939e9f16f9226a91ea86d2a340d85e8cdb54eb76c59b040bea17977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a3f2309939e9f16f9226a91ea86d2a340d85e8cdb54eb76c59b040bea17977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a7500e4b36bc76b21b6820d457bca0349eec466f05a7d03a2eca0f3cea26cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b62d256cbb6e4abe5d427c7ba539f57629fd583c655440eba7ce5e18ae1b29a"
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

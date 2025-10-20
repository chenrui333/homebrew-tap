class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.6.tgz"
  sha256 "e2d48343c94eca25772e31f551121f348a8ec959b25d9110434a50ab473d8d3c"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "e68a6be7f0e00ec8210367e854568d039ef999e6a3ec7ed51607a7652a84d31b"
    sha256                               arm64_sequoia: "a83acf50d6713be13a3ec77c8002fe2a65bfb203ddee582cf93117fea43fda87"
    sha256                               arm64_sonoma:  "09ec8096c1e8d77f83081572a8f4d14cfbc57d34f439c6cc8ff3d90f9e847e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ba740996babfa572bf88638b51122d5f61e1db2762338af1963f36bdaf8a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e990602bd4a6ef163dd13d658a62ed1078d418097edba0ea2f6396ac75b072"
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

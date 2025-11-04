class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.14.tgz"
  sha256 "1977d5266cccf00153602ed20627a783ca40f47803df7fc7fb1c0936643cc1ac"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1e46e5aad67ebb78f642e6a529e904edb7e84a44aa709fa290e36db3c946d274"
    sha256                               arm64_sequoia: "fa7317623b44db962669b28f98af7824138e8a86f501099f167f7699f5aa385e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec18aa343b38356c964e5999d4c128421759f88a1e645442e3cf2992eabd31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1818a01567a55273bcb9fbe2a6b972ce3bf07b4a696ae85a10fdfbce362c7acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437477c425c7b13d8f3eaab8c9ed576973c8a35a72e32982325e9898fe092be8"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.22.tgz"
  sha256 "a2c19a35bb451998f9c751366b6e7da4301ea6f21a1d97f72c8c39e34839dac3"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "afc51362ab90eac67dc30e81af12e343d427125608a9e21e5cb83bdf7270e692"
    sha256                               arm64_sequoia: "9117780ff6ce455843f51ce5e01739b7d6f8c2f0207527b699c0ca5e7e11f3de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb5084b623dc1b467e783ad28414ff0dd46932d048fd8e62cac851186efbb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d9bf3b3324bf51e086091e4213fa822462cc7d0ddd415ab6b2c840cbd95192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4738077db86a7c0b1ffc1fc169a61ad4934c91d9ed551d297ee6a6d25f7c2b3f"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.0.tgz"
  sha256 "64f38b505be6a4f389ba7a07e09e01a5dd70ab7f2af5215c0099ffd4a92753b5"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2d8e9fba0884178edb012846c7c4fa46cba426366f7eb48d149fd598837e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d8e9fba0884178edb012846c7c4fa46cba426366f7eb48d149fd598837e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d8e9fba0884178edb012846c7c4fa46cba426366f7eb48d149fd598837e4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d63b8ff899aaa124fe16d0c78a70c4923735566ce23a559f4f318ec68484c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74cfce67e6250e2253e53c702d2985792a28494fad87c7496c110c308bdc2d45"
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

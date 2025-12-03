class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.0.tgz"
  sha256 "64f38b505be6a4f389ba7a07e09e01a5dd70ab7f2af5215c0099ffd4a92753b5"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f677d8780d5e33abde693d2d101f0fa64cda131b18a38337ae0e0d00a7f688b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f677d8780d5e33abde693d2d101f0fa64cda131b18a38337ae0e0d00a7f688b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f677d8780d5e33abde693d2d101f0fa64cda131b18a38337ae0e0d00a7f688b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a3f4054b93083745a3e6ba53ac9ef5b765614bc1b335680efa9644226478d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674305625703e17f671a40b5b19e0d8a6d1a434aeb089c96c322fba6fa2d6bbc"
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

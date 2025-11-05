class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.15.tgz"
  sha256 "168260effad77e49298f933861bbdd37994c2707d6ea11e6c51f4d30b7d2a81a"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3dff6499785eff3719c2a2ee92caef07f3e3a28ce5fd0dd14ea87763cc41db2d"
    sha256                               arm64_sequoia: "67851bb98dac6dbb20ad6bdcbd4eec8299359d3ef211bff97edc9d0d6fb695c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167aa8634c0d267199c41f292ed9f732e657b3cc1b3bffa5953f0bbe0035983b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebdc409ad340521c5b5fd73e3e1c11326924a1ef0cf82db0e90126cac51db892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87dac0cc9bd382bcac99034ec1a7375a9d589c6c6a731dc65d402aac3cfb28ba"
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

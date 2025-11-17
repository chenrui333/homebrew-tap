class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.22.tgz"
  sha256 "a2c19a35bb451998f9c751366b6e7da4301ea6f21a1d97f72c8c39e34839dac3"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "48da6afea63cb55d86243eafb7e9560227f29516513e06a9db12a4af2ccaf263"
    sha256                               arm64_sequoia: "aceea53f91741f54d5475bc9e4f4a506e5ac896c9637a85e5f34e2e877185d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930484facd5b247918d2b0810499d875a840098f1f3ec2786c3c5425eb3d35d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c36e1de4d803e9ad97170614623bd3453ceac93bff232767c5315c2f005b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372e0a69f9f2b495a5c92fbf0d228b383483ceb1a161d19f6951bcc58f15cd3d"
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

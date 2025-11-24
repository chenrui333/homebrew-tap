class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.27.tgz"
  sha256 "0d996552d9d4749822b2359ead44b8fca82fc5270702c1b20fc54560f7071735"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0bbc8481cacf61e5398ea28cba97f95cd902cf9fde18f23b36bcac1292e32503"
    sha256                               arm64_sequoia: "1e0a70fb7413caa60ce815e098f5a930c46edd415a010c09ff45ff29f23f4c18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e9beb1b2084669661eb8aea4a462b36b89913a424832398259e1a16d58cce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e09815c5a69b14c4cec14774828289d4c415cfee4bcdffe3f8470ce0bd358d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9c9f4a6713380ec1850cca6f0955bdfcd1bbd7a830e5ed353c55c6aea230bb"
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

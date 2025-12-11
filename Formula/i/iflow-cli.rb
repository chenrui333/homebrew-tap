class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.6.tgz"
  sha256 "76578718701032577f666561433cc51d2aaf11b63b5a5cc619559a46ecffb8ce"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffeb1cd1b8da91841ee83d0bdfc89900ce8d7054c9bd53b1f6e14ca8c6f86a27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffeb1cd1b8da91841ee83d0bdfc89900ce8d7054c9bd53b1f6e14ca8c6f86a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffeb1cd1b8da91841ee83d0bdfc89900ce8d7054c9bd53b1f6e14ca8c6f86a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d27b18dcd1a5b0b1c8ba47e7a3bd8897f4748746c3fc87539705e0d9f5b76cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85c3a80d1de31475bba94b6f0ba98e45f2c6e49885fd7621491a639e5a9e0a8"
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

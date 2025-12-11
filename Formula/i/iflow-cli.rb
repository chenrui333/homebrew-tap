class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.6.tgz"
  sha256 "76578718701032577f666561433cc51d2aaf11b63b5a5cc619559a46ecffb8ce"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ad85eb10e5e7af62d5c4fab1d0f09f11006160bbf221be800106fd247faf2d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad85eb10e5e7af62d5c4fab1d0f09f11006160bbf221be800106fd247faf2d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad85eb10e5e7af62d5c4fab1d0f09f11006160bbf221be800106fd247faf2d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b76a58b7bfb7af9b5b2cfd706901b913ad4739d7526479aac72310e98cce78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e12ad67c39d9ebdf6f920b358c0d691f4043c6b7121932ab33fd1fd3e50ff21"
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

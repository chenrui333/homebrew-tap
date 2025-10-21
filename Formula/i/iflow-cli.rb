class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.7.tgz"
  sha256 "f02ff284ef0666d96e345725de908047f97d9d3bcd9c43b04a4cc0621ddeabfa"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1de213a2a50d6778faeb11a3d04da9f9b1767966ff9331a31fb1a3814ccc9de1"
    sha256                               arm64_sequoia: "47463a25962c0b743145452363aaf93ad87b984e4c7be2eaa3d034e3e2caf684"
    sha256                               arm64_sonoma:  "3a8c2a7e39ab58042bc45be4ae1fd332367a93b508abcf9b40005b2cbfd2b8b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9a88576a2d21ffd70f371f62238d1585bd760037a9aa9bf888c035680f7768b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c31368af3644100400536939c79ff420dd6ef500cde9dd12020a6b7182ea4f1"
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

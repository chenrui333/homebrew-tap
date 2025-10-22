class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.8.tgz"
  sha256 "72e424cf2db497be23b992687ac69246be6be74ad6c4c2e33cf08d5c1c61b514"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "233edf38993a96ac4356866b59e9ccdf53719258a6528e1949526d9e479aa6bd"
    sha256                               arm64_sequoia: "29e4ea8e532fbe6a311b9740823785c777bd0270b1ad349613c15f5a715e7e22"
    sha256                               arm64_sonoma:  "4986471efa235ec57ebf52d82e00a716958d758d6c04549bcd234b4032c82f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b69a899eab7b76b619b553c8e9b64923e1d556dafdc89461f57e61bc1f359414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec45ec2be9b7de0d1c6b082e37965c2509ab404550e3a8466d23cee69766221"
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

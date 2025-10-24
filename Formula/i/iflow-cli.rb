class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.9.tgz"
  sha256 "abad636411f9ceed07354be00146856cd49fdf8ef3816aa1e44b2fd88276ea59"
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

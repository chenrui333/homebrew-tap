class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.10.tgz"
  sha256 "984542e16a64f798a67f0c3f9ff5b43ad11b4bdedcffc083a265b76b99377594"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4e98db1d4a83de9b6894851b84bb04c2a3fc100d87a928c3a8f9fa4ddca090a4"
    sha256                               arm64_sequoia: "c165ac22d26732ee7aa26dc0761789c68de1334c1d2fb5e97abb9c2a0681c304"
    sha256                               arm64_sonoma:  "586e34dda80fd839bb133e9912776516864482a2f7fbc14c8987851c474eff12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bc4f13d14b865e6cda35a2c258c7ff712750255bb0671bf9e8979981eb24051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4827311cdeca6e53d8c86e2f61e9defb32361be6f5d122d7a7a18bcfd84a54d0"
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

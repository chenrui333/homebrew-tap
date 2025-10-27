class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.10.tgz"
  sha256 "984542e16a64f798a67f0c3f9ff5b43ad11b4bdedcffc083a265b76b99377594"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3b48a6255d69bd9082d8d5ba55487014f2e74a12b711b2e0f29ee8ee1d24311b"
    sha256                               arm64_sequoia: "c83fe7cf12a27cddc8bf66b18bfcc4d8a234320498f15d7b7afe09b75ec6a6e2"
    sha256                               arm64_sonoma:  "a8c310f65e16f8114e477f0d67b48ce6c2f7657562c2414d2bc1c22691ee0af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "582811ddbaefa898ee9f3feb87cf82abe5552bebf0b9aa5a22997456b5f4279f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b2bae9414c53a11d98d0e625d02b47d95bf8a7ff2b2ba4e5fc0b2df666f69c"
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

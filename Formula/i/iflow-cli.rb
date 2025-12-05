class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.4.2.tgz"
  sha256 "a0cff12cbddf82757a2ffc0dcd4c849ba0f68607c29d67ac44106c12e95e4156"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b2a889e2c2bb705d4764895864fc49ce2cdf154097771ce52295b344260590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b2a889e2c2bb705d4764895864fc49ce2cdf154097771ce52295b344260590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24b2a889e2c2bb705d4764895864fc49ce2cdf154097771ce52295b344260590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae9c96638f7b1f4ebdeef6b0c9333035aec172694d9cc63b07fb148a4d170c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58219ebdd2976759c56591f68d8b06eddcfc32a77c48da60cdd39b4b961c8a99"
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

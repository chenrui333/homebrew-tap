class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.28.tgz"
  sha256 "63596788bbd6a9d48f5805b99f700aca714d48773f96271686e82e115907ba6e"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a8c271de61e19772d302df8dee9fe01733602f328614bf21d085718faec11906"
    sha256                               arm64_sequoia: "05a12ad4bcdb695fea4d6b381808e9b66ea651f8aaef84eca7de34063ae47bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03fa0b96833c14262fd42f55c57f097ce12ffe7ef15672ee700a558fdfb85ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140d25539f272ccac2d6ee386868d89f84670f49be5912fca0ed5889806e32f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd0b5e46035f521d299e279deba7a1da46347a0a584d9bdef2fb98a8a189e85"
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

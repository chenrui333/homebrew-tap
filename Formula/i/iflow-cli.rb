class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.19.tgz"
  sha256 "c3629a444d97f5f87b8a0022549feef48130af7653291cfe9e7437512a8acf9a"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "bb9f091ec9570eaa26417a105e954ccb776809264f1656fa566611cae9b45c96"
    sha256                               arm64_sequoia: "6832d50c2aed0d27aa1d19be35dcae87af4ac2f9a3ffdf5ad90084229faf1e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99669304f03ce74e4272dae466eacfc4e6fed66a3e5661493d077129c2e57d04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e4e2336284434cad50d9ec33efe89116e27c3f9d265294ff48df9b62128384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3802491d55f720c19328d1e05b03e3e8ccb0f76509bdd6295e7b3edc2f9c654"
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

class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.5.0.tgz"
  sha256 "a830fdee839748455c5dc75bc0dfea42e3637b27969db8bbf88282c029e9adec"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1adfbc759f93fd6625b2b2e0462e959fdc7d761ab1107d6ebac2ef76aba95fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8da95f51d611d4c77c9d2a09f78967e03c2383795697ea2e37dd7030a81df9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b36ac399224109c912cd9998278d41f61f0cc76420c20e1203522ccd058eb8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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

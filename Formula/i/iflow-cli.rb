class IflowCli < Formula
  desc "AI assistant that runs directly in your terminal"
  homepage "https://cli.iflow.cn/"
  url "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-0.3.18.tgz"
  sha256 "fe0e33658ac78f8dd2fa724ab2a798bda08bfc702188b502819dccf7d266080f"
  license "Apache-2.0" # derived from LICENSE, but no source code for the project in https://github.com/iflow-ai/iflow-cli

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "02456e211678ab8e2d6c896e239495fb2eb8e38983452f743274d3f4d3139d68"
    sha256                               arm64_sequoia: "d36f5032ad7ce24a8125926d03955140815bc619adbf197f37afae9c21d558a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36669b12a1d06af586647306bb52e6547f151f0bb6e4fd582dc67f690fe60cc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8585e45420fdedcc8eeccd7858ee625b519c380df1f11ffe7d23e51cbc2d00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac54a26486a675980c02c7f6571fa4163e11f9e9917d5ee0c337c0f5d1ad76e7"
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

class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.6.tgz"
  sha256 "7272a1c25651dc0e593767cae6717a87ef7c8253c214ac7e05a1a2a52a92c266"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a86b4780ccace42a17049dbd169d772d08ed98874748b507e85ebac2eea1f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2fe88cb30ab9b474201a7c1f90a7d40176ebdd50199a882ab5c61dc67fd78f3"
    sha256 cellar: :any_skip_relocation, ventura:       "2c62b5ad9b53911cc7dc32b6d10e76d7d3ecba56aa036fdf5c2fe30a004bab09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d0c91d5a8fae5bf8bbc39a59c49a91e38b863380c46b2bfb23985d6fa09a1a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nest --version")

    output = shell_output("#{bin}/nest info")
    assert_match "System Information", output
  end
end

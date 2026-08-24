class Opencli < Formula
  desc "Make any website or Electron App your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-1.8.7.tgz"
  sha256 "de016839c48e6b3f64a629e7fa715de6f483b31c071c4309f2c55e4a18c48af4"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "32d67ee367a69b8c2c0c16b394a0a3b7bbcc0912d2edb2e250d5ebd1120b60ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencli --version")
    output = shell_output("#{bin}/opencli --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

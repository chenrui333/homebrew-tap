class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.66.0.tgz"
  sha256 "bd8da2795f787eb25e6848a9868fe1d51432145063b8f5f25d3d332151c4bd31"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "35afcfe634740e69a5e471f3b32d0782ec2ea21c079b144e990ce9926c1fc16d"
    sha256 cellar: :any,                 arm64_sequoia: "b84c419bd8fd1fa0000c07a23cb63cfbfd6f1c3ce4f6acc134b9a275abf8f92f"
    sha256 cellar: :any,                 arm64_sonoma:  "b84c419bd8fd1fa0000c07a23cb63cfbfd6f1c3ce4f6acc134b9a275abf8f92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a55d057de68b12933c1b736a8085550321e685b19712ecff4d4bbb836c67c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a36a691267456007861a2a519edf60a685dfe72b60e1cf76bdef737a475a817"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    assert_match version.to_s, shell_output("#{bin}/knip --version")

    system bin/"knip", "--production"
  end
end

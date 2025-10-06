class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.64.2.tgz"
  sha256 "16e66c80b428e167bb00216c84071a89af793591401f7f907b9311015aaa1ccd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "384d8c73a12f0ef368050b6296b0573193d867619340b3fda8f676225cd9e61e"
    sha256 cellar: :any,                 arm64_sonoma:  "75a9863fff2ca91e32b7f921a02ed049e1cd0f994ef615a5c6a95e3521fc592a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9721335578ebdd39b600e6fd4a0f2943d580259406f954279fe93f84e2b3709f"
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

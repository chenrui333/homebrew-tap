class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.55.1.tgz"
  sha256 "2dc9095c303aa4990f2349079b457d49fb4c6a3699123760d2dc5027efe16eef"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37462b770ee7bd764f0b0a62a603f0f9f78094533fd9ff99560b95a6f104280a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "333b133aed658f5af657ac25b8e319e2c16bc77d29e16c556c2c5df704ef00f0"
    sha256 cellar: :any_skip_relocation, ventura:       "e89021ec2a45cd29990c8f406e39830c8ddb05b07f39849f91ad22abe3b098bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0058c5b0c974fd16041d7b8a85fa7ed9c3b37730baddf2dd066530818c502222"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end

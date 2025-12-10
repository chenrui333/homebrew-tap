class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.73.1.tgz"
  sha256 "7d6709deab0bae8e9900e947ffd480c988e791c58efcb535062d81eeffc0e89c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f5ee54e14764c20fe484b99f8cb7e1923ea88a159893d9e4d57aca797ca447db"
    sha256 cellar: :any,                 arm64_sequoia: "a7d4d7b78108ee00cbfe4929ce4a92a7edd4f5a8ab9f5fee55bd77d8a0584720"
    sha256 cellar: :any,                 arm64_sonoma:  "a7d4d7b78108ee00cbfe4929ce4a92a7edd4f5a8ab9f5fee55bd77d8a0584720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b83613ba702b8e76128ee2c4f6a0b6c60abbaea141c403c839f919e77b23a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6330bc88fd98f3354dc9b84e3882f5d4edcb75aa4f2f59644a34673518e1298f"
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

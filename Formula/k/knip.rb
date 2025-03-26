class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.2.tgz"
  sha256 "760a8b142af698aab0ef75670915ffd9d5da3f03fc15fa5c1986604a20b4b072"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1892d64959a73f449e76f0d953ebd16d65ddd69e171ec4d71eec83452abc6183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2b5ba77ef7ad2a41ccf5520fa85126d8ead92de7defda3c70b50f373c30f65"
    sha256 cellar: :any_skip_relocation, ventura:       "a0dc828c629f8176c47b51a5e4be2ef57a0d93b41d9ef089d91c50c7b98e2e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ce65a15b8ae569a6ba057a66f8fe2e539ced15795f56ac72bb280c0a0b9a8a"
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

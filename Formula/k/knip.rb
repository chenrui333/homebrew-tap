class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.52.0.tgz"
  sha256 "3c502ff7e78a0eadca2a4f18b862f0db359d88e77e5b4f644cd1fb2097cf64d8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe75bd601ec7a0deb71af51a9eee034e2bd3ccb92760b8d48d250314b121cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec5f8fc45eab19445370f7bef396eeeda31360cc66aa45d343a0b700bd7139b"
    sha256 cellar: :any_skip_relocation, ventura:       "657fa1def9dd7de012fd9a0ed1520d35d7a74dace03bfc28546b77ff10442b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f040312c22a26ca4ac4ea85f07239861e2be71ff87dc702290148f9ad7d83850"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.52.0.tgz"
  sha256 "3c502ff7e78a0eadca2a4f18b862f0db359d88e77e5b4f644cd1fb2097cf64d8"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bd6e9160f26ed5fe3679a26a93a2e35eebadf752073e0cd650fc466c1640ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48e4b5676d6aa3904e252043478c0f2e99272e993b222c41e2e76354586c7e8"
    sha256 cellar: :any_skip_relocation, ventura:       "089cafca5f611de3546971f289910cc7b130a8b7c10d6c2068f10d46c9073cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089a30caac552494b9b93308f8848a7f95dab43178f4ae2dbf4f1808ad7729b3"
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

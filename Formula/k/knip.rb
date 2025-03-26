class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.2.tgz"
  sha256 "760a8b142af698aab0ef75670915ffd9d5da3f03fc15fa5c1986604a20b4b072"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d9f7662261127b74b204a0296ab842dc0ec964b3e8b0055440663cb130b755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d4cbae77fe70a3f12eb428d90e44f25a52ca4d3b75d6c58fdc812acbcf31eb"
    sha256 cellar: :any_skip_relocation, ventura:       "75561723a87a87e3492d3f1f91f154892f57ee8f8e978c0be93e17f60dc04d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4275a1768e43aac091c571ca0594597d6f696bdc273e0b0ec49567694cd2f94"
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

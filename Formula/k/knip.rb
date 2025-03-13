class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.0.tgz"
  sha256 "465944747884f543adfa3bd79484baea2a923d90db53a6f51d7197780182522a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7c0f311067bde2a37a126871c0196b85747c58ca4512b58b3d306c65a5f4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "441f6b60675fea325f2c5e3aaa88b35aaa6c2330022d48d22713f702eed4bf6e"
    sha256 cellar: :any_skip_relocation, ventura:       "bc0ad04fa869e2a7a8ff20e785735094e4550e6c887b4d28a7749be98850f08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5c5b7abbc38fc46e270654fc43513398e18400a49f398bb5802a3c2a252e7b"
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

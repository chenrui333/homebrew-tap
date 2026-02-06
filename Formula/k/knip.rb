class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.83.1.tgz"
  sha256 "f038a8dcf5590fa3c9ec74bc0a7e732da8766fefbfdc816018ec1a0606d6d3f4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b3dced20f794dd04e12b1d8396d87252f2185a1cd219ec5b0283d1c96bef85c9"
    sha256 cellar: :any,                 arm64_sequoia: "cc6b5fcfdb1864cc4012442d0b30bcaa2436da7c04f760ca67c6795337c34b6e"
    sha256 cellar: :any,                 arm64_sonoma:  "cc6b5fcfdb1864cc4012442d0b30bcaa2436da7c04f760ca67c6795337c34b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8003d55c0784113203f935f5e64ab91702c7f703151f8cd3fe361a7af8c30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd9b62f2ad4a566acb9cedddf1c67ff109d36c3032e9cbf110f9f1063955522"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.87.0.tgz"
  sha256 "aec0aa5bb9101d0c0b6e6e9d6b61a52306fbe3cee9cb4ee144cf6f08bf74a2c9"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b795543fedadb4cc5f5fc73ea2c87d6486b83270523cf23f5cd66ad33cfe3129"
    sha256 cellar: :any,                 arm64_sequoia: "2cd5dc3fb47896f1ef6c361c80f70c2f22b2058965713daf97a49477c4c032fc"
    sha256 cellar: :any,                 arm64_sonoma:  "2cd5dc3fb47896f1ef6c361c80f70c2f22b2058965713daf97a49477c4c032fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf1dfa77c0f4af0b7be56409995ac8a1986e69e030476256ff78c7ead49e971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9a95f59188ccb7017f01f590b4d85a023e6846f7c5f53b814bfcf03744da47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

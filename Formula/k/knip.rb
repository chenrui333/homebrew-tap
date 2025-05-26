class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.58.1.tgz"
  sha256 "5ec943591da24b01e882a2f5a7054466f53aeecc52a8d1482dfe4b31ec7977e1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "aeb8b56a6f4eac25c572c4d5728cab02c705f8222cf67289e3bf4781c6a1707e"
    sha256 cellar: :any,                 arm64_sonoma:  "6302410e34fcab4e3e0d1eb788a65e1e8bca759ae2d4e7c286af3663c2b273b0"
    sha256 cellar: :any,                 ventura:       "def98c3c79645eddd8e868e32a9a0d1ac46783f784414a4c07392cfe7506752d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf040238950694866ffc18e348e1e91c8ab4b495c82e046ecd1e4ff3fa43a0c7"
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

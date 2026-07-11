class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.26.0.tgz"
  sha256 "3b94d37545107f295e20ef8a853fd03ebc4c963aac76c4bbb0f8d953d2059433"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c4451f621b24e3cd4cf82ea9e4267cce85d83e848c46fac23d5d6522a527cb51"
    sha256 cellar: :any,                 arm64_sequoia: "6bcff9b92e20fc6693a1bc11da9ed62d2e2c6fd62de498e8aac4fa616816862f"
    sha256 cellar: :any,                 arm64_sonoma:  "6bcff9b92e20fc6693a1bc11da9ed62d2e2c6fd62de498e8aac4fa616816862f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c78c457911d7f24ae32eac2de58a036e17aae2f6c74f26d3b7c27c6db73452d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d2329a1ff7330917959a3b9c71e7134ace5544dcd0c1e4149fa0f4b64d1a7d"
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

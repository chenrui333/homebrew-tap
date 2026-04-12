class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.4.0.tgz"
  sha256 "94a0cc9d53d57a84feb577dccd979c7089210f21f2f24684dd0a0b50d5aead62"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a34a7fe240505b0fef116cc8194d866ad424a982ec8182cff16780d52cd69202"
    sha256 cellar: :any,                 arm64_sequoia: "4f452de51d7d1568bb26f99a3f92b2f4913acba3e4d693d8e72575580a74b81e"
    sha256 cellar: :any,                 arm64_sonoma:  "4f452de51d7d1568bb26f99a3f92b2f4913acba3e4d693d8e72575580a74b81e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e94b1007b36dcbb4857a7bdf79ead1abf15c03548f4a99684e545294156201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0eedfb36dd6e9d9de5f3e8592f615be0bf0570427ce2df8789806bd2baaa1b6"
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

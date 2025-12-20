class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.76.1.tgz"
  sha256 "2fcce404efe49d278582dbc201afcd174e1414c3f54a2b39bc1f4db3f494c847"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1a20a4d57663a3f5b8d0122c3f47a83763f30723a6a0b5fc8f7efdfd5a2a3884"
    sha256 cellar: :any,                 arm64_sequoia: "9ecd10762227fd6b54ad7446ab75a1ebfdf791f882231237124deb7b5e85d05e"
    sha256 cellar: :any,                 arm64_sonoma:  "9ecd10762227fd6b54ad7446ab75a1ebfdf791f882231237124deb7b5e85d05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4969851039f42b24bc65e7f05497bcb046ad4c758044fa0cfdd31a829b4f0a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fdfa66f0488e21665e6f0edab86ffed695b4cfccb3acb3e3b96be1cde24076f"
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

    assert_match "Knip found no issues", shell_output("#{bin}/knip --production")
  end
end

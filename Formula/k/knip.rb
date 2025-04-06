class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.47.0.tgz"
  sha256 "d1153e701edc368b43e85aeb462bf0e0b76fdb0dc551487290b5b88f480ff3bf"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2023b1f51f9e31bb41bd70924bac68a8288ea8b0eec7853c6d299e274cddaa8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137bf0bb1a106a3566dee6215b6502dd69260c4a26b5fda8be03810788dd4258"
    sha256 cellar: :any_skip_relocation, ventura:       "a81453f25e6f136b50e71ceac14ef6248af39536dde93ffabeb5e8c0e05cc89f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02851445f6216b244f2c92cedadbee9ebbe6af9ca5239662d183ef8ebaa49cb3"
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

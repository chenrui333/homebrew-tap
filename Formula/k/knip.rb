class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.60.1.tgz"
  sha256 "4f35dd74efcb4b17dfd4e1a99f765c0762d3dbd88481c89fba0a05b329057137"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "aa589d90c98b5f42729e15274152e2ff10ad71b295758128a30c549acc76a911"
    sha256 cellar: :any,                 arm64_sonoma:  "679e3fb50ea93dcf44eebe082412599b311e7d1023bf625a1dbe5f670653f15b"
    sha256 cellar: :any,                 ventura:       "a1a85d9a14a2a5b85b5dca99d96a590987a23c7c655511aa1fc6c16816e8bed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437b482addda1262c214445af14fa1be894c65f6922b82b19890dc19b5e5effd"
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

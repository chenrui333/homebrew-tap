class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.67.0.tgz"
  sha256 "3962a70bfdc4cc495eecb493e0e52160ed7d9d8d451e42fd96dea898a1dfdc08"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "337f2c922ef51350af7bb092cce52d06b4e20330286527f1ba9f6939394da3cf"
    sha256 cellar: :any,                 arm64_sequoia: "9cefd6c20a521272d3b84e930acac51fd74fd605838a3dcf10eaaed3504d2a56"
    sha256 cellar: :any,                 arm64_sonoma:  "9cefd6c20a521272d3b84e930acac51fd74fd605838a3dcf10eaaed3504d2a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854288602648ab41685b31d16785b018a2f6382a383781254bac32cd861ff8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ea33fb87524e1f0edc1b97f136f3213211bb875bb223671fd02e00784b4516"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.80.1.tgz"
  sha256 "0fc972bac66d816c1436bd3c3940d511d6d152b28b77566e9bb47c5dd7a7bcd5"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8ac624d860249c0007f85bd326486340919ab0bc302577772b9e4bcc9f409521"
    sha256 cellar: :any,                 arm64_sequoia: "8c2c85d2204a816392c13215a9e1ebb5ed0c9aa37596d7c0aeb63b4e8428a738"
    sha256 cellar: :any,                 arm64_sonoma:  "8c2c85d2204a816392c13215a9e1ebb5ed0c9aa37596d7c0aeb63b4e8428a738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f923349ac47e9d3f4e3ef99def39c5c429db85276150d8563a9b35ee5e388980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ea5d2a8ff0dba54accc9e7d36cc9b7bf9729c0798b49fc1d3fc941bf85d9ab"
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

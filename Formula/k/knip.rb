class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.3.tgz"
  sha256 "39f42b4f8df81bcf219c8cc0861d7568dc32bf815d6f67d3da689f4b428a8730"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f933a3565ac5d65983d055ece289f1f59187cb15dbc9f2f34fef86dc810dc0ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f826ce769fda20d7b6537595e1012827d02c169f30e0478a46ca22017496ef27"
    sha256 cellar: :any_skip_relocation, ventura:       "1875e289c165427e33202bbf0386270f0c3a45037b3edf92ad5621e59f4310ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12a22aa23dd1a8fb0a53194f90bd8bdcd3e0ac01ca5d1dd4de1af80edd40b9c"
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

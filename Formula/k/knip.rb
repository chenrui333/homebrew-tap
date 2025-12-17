class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.75.1.tgz"
  sha256 "4b5ec4e64f5a8d878b6944285ef5d8faecbd337e7c9a5a55fee55bde8d6cae85"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d9e8d8f11ac4921bf28e3d3b7762414d7e696e9819c15c8131f095dd70b6c393"
    sha256 cellar: :any,                 arm64_sequoia: "428959f6882500f9479c5b6bcfcc65435a8c6b7454b5879c027b7cb69a5e909d"
    sha256 cellar: :any,                 arm64_sonoma:  "428959f6882500f9479c5b6bcfcc65435a8c6b7454b5879c027b7cb69a5e909d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd2f0bf6f4ce53a8b9155edcd082ec3fe1dc327b512e335d3ebd197bb2dbaa3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e48c322e2847cc18ef71bfe5ee181d4e760981cd0a8669ab43996828bf9848c"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.58.1.tgz"
  sha256 "5ec943591da24b01e882a2f5a7054466f53aeecc52a8d1482dfe4b31ec7977e1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "1caacd992a7cf263a13d7bb36e2b023b19f3230cfce46f291e360c97de0b7c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "58ace9a6a7b09970941e3cd5d98f545cda64e86e8c8985b1f6d8a2c651ecd6ec"
    sha256 cellar: :any,                 ventura:       "4260ab4ef91dc43555778a0784fac14ac28f57274a329db722ac48e5e65318aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e0b12a4cf78b67aab62d582a42fe9a6ad74ec3390233381b5786f3a0916f1a"
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

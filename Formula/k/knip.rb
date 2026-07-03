class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.24.0.tgz"
  sha256 "d6002222ee37761546ae9653bf55ff7c36294aa4900b66661c94225fb9d246c2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "86e8510f7e1025412e0d5e385be16587c24dbb6da20e313a02952fc2458fa547"
    sha256 cellar: :any,                 arm64_sequoia: "3209d442b2a8f317ff48eb9f7dee4cc84beb6b2241021abf7a6bb8fdddb4cebc"
    sha256 cellar: :any,                 arm64_sonoma:  "3209d442b2a8f317ff48eb9f7dee4cc84beb6b2241021abf7a6bb8fdddb4cebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b9236bc003d706234b0117016b638e76c63770d7a58ac7fe8899449a82443c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660f49fab742fe80289c89b1d48a65268dade740ea36730f3dd23bbb33138f6a"
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

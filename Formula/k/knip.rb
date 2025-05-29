class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.59.1.tgz"
  sha256 "b441a19739c99ec45679079143682cd83f39638459022c3d47b2349db8197844"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "88ab8ae3e8a209d348546b5b992c7fc34c8d0dfee933852c0fc21e8470d220c5"
    sha256 cellar: :any,                 arm64_sonoma:  "6bf1eb170460c77a1357172f52073866b4855d874d5b466f9328b221640e18ab"
    sha256 cellar: :any,                 ventura:       "b77051d833f89b9d4dd1e33753bbafa20b8f5c0d66acfddc5c5d2d1a0d94ce2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0dec1665c9b4f5c5e2ad2fa5629d6960615dc1f8df6104cee033833d681206"
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

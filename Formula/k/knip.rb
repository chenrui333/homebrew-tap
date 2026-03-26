class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.6.tgz"
  sha256 "0645c6b1fba38357cb91a369cf932727a16df709217d94d11a71cff6f21b90fa"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b5621b24a5fc17bce2bb60164fc16180a14d720e4143ffb79f19340ab25683d4"
    sha256 cellar: :any,                 arm64_sequoia: "8714b5265cd60ed6f0fc93aeeac82108e196fa0f429076fb17b1e6454d9eb93a"
    sha256 cellar: :any,                 arm64_sonoma:  "8714b5265cd60ed6f0fc93aeeac82108e196fa0f429076fb17b1e6454d9eb93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c48c45ef7e319068b81d8c67bee9d0dd965bfbe98e3b1aa089b83c330a80992f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0431c017d512974929a77b3ddd64ff1a34d8107c00fa1acf0d7259dd4aee7975"
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

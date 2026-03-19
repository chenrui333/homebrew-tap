class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.88.1.tgz"
  sha256 "718555c3ddde29655a527d909bda5d2ac8d0fa29aeaf78690c5787153a9e6191"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bdd568e9417e479edc725e6ef204d4358f9e08f3801dc7402a2a53ad33046814"
    sha256 cellar: :any,                 arm64_sequoia: "54e81c35848633107ee06bffe9de5b942467d21db5eb9341cdbd354812d52932"
    sha256 cellar: :any,                 arm64_sonoma:  "54e81c35848633107ee06bffe9de5b942467d21db5eb9341cdbd354812d52932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f0d28bc885d6305eab3c992798e007c64bb144c30346d9974750b6d3ff138a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90dd772a0d890ff839604d7f20ff21a597c1b3205ae7de6bc6f44f71b24b8398"
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

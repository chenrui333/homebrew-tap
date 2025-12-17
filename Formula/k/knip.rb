class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.75.1.tgz"
  sha256 "4b5ec4e64f5a8d878b6944285ef5d8faecbd337e7c9a5a55fee55bde8d6cae85"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4d1e6a40cdaa75769012538a68e7f42919c7f2ffd8eb4f755bd835654a3de74d"
    sha256 cellar: :any,                 arm64_sequoia: "50152cf60955b6575448a0fbd945c4368e2ed84068ef3b89ad4d961c6e98a768"
    sha256 cellar: :any,                 arm64_sonoma:  "50152cf60955b6575448a0fbd945c4368e2ed84068ef3b89ad4d961c6e98a768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb87e42a950a394d952d3780cee50dfcecaf3138ec43995359a2857ffd351902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddce8cacb84bd82c09720e5473975c62af7950622c35b4081c48d414ceb0495a"
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

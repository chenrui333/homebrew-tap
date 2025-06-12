class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.61.0.tgz"
  sha256 "9769594ad0812e3ea68f3b269c27045e9064097da62f6fa592b7319ef0e9a846"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8ec99f37b1eca385511d1e09719d886732142ba30badfd49974379af697833dd"
    sha256 cellar: :any,                 arm64_sonoma:  "4adac6049d447c3de45c9dbd78633e13269a5d2bac519a0e11a9e50e236a6b49"
    sha256 cellar: :any,                 ventura:       "586b12062171305c5c9fe87a69eee51ea0a66332b0d9338091be1bc5df3a290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa9c91f89e8aa8e645dc88ee33151ce3341e2cfea2101f572bf90778c2bf111"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.44.0.tgz"
  sha256 "928ec80610e2eeacc39c8e14bb327363f836bbc36d224de51364baa4f847d57f"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e6bbdf1bd871df1c4cba49564ade9cebb43d94bfcfbe85c4126276527849b2d1"
    sha256 cellar: :any,                 arm64_sequoia: "e6bbdf1bd871df1c4cba49564ade9cebb43d94bfcfbe85c4126276527849b2d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92be7fec44643155c5cf6f07db2e3e970123a9ae297ff070aaa05eb1678a5d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8221a9fbc563395e814cad39fd74d8265875b0b244efbc050fc13a7843713c"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
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

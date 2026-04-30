class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.8.0.tgz"
  sha256 "eb1d98e6925fcb97f62b3d8bdd90c76fb32af0977eeb5eb80e8a4bdcb58002d3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9c0d24bf10fe932edf074ad433d2c76aa044f689f7bb3c422defcb4569a48351"
    sha256 cellar: :any,                 arm64_sequoia: "29bc78b2b24b36f37de04feade3a618cb48c7d545cb13d5ca1bae488ad34742a"
    sha256 cellar: :any,                 arm64_sonoma:  "29bc78b2b24b36f37de04feade3a618cb48c7d545cb13d5ca1bae488ad34742a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afa599deda13a632b85dd437873e14888e823f14aa063f6dcbb4bc8c372695bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d265ca63dd6427b845c5371cf307798b466a85b684e643b690a5d703a3cf3005"
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

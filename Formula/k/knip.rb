class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.5.tgz"
  sha256 "0127424111a13ea4e7c12decb58f9c2c695047f918f8121b20b6f15a33bef365"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e0df8afdf03755dba277de4b958ce2fba6864a0d1d5d811ddeeb2d32d029a89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a0ed41a90d9f9265fb153ba0cdf29031640c1c8348dd4312d05cf943e06860"
    sha256 cellar: :any_skip_relocation, ventura:       "c590ade1fdb3e5e9a69c419773049730cfd87b50fc7b3fa8703860bba1cacdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37bc22556b9728298337ff1f09a87780b6df58e1b6add4156822079429cdda3"
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

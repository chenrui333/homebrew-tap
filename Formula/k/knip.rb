class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.40.0.tgz"
  sha256 "49d419be56a922ebaf894438816ddfcd9c82fe0d0fe8e798db79cdc320510afe"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0650a32f77d788a35c716f4ed852c76f2e32852cb73f35934ee658e85fe7f044"
    sha256 cellar: :any,                 arm64_sequoia: "0650a32f77d788a35c716f4ed852c76f2e32852cb73f35934ee658e85fe7f044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d935747ab7bfdc702b1e285a81f1f38ce57f9b61f2bb086dcbfe049666be85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc9a06117cec1953bc6494d52f4dfae0a7edbed6ebd9fc66d92acc8e8e9082b"
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

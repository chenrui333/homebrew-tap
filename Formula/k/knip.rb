class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.48.0.tgz"
  sha256 "3f13c23f7f80ed6e60e953e1921fe6f6099929d167145c211382f8a335fd3755"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4d6e90645a0e226fc6417dbb2cb1dbce3a47b7db1665dcd2a78b7d1b8dc708d7"
    sha256 cellar: :any,                 arm64_tahoe:   "64e9d375f1e2821cf36f3dbaee1a94b576bdf221a99a638b8fcec232a9782249"
    sha256 cellar: :any,                 arm64_sequoia: "64e9d375f1e2821cf36f3dbaee1a94b576bdf221a99a638b8fcec232a9782249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408257b4efb4a4b9b7140b682eaf5a6d9a30c93affb398e43364fdb013c9296e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97076f42f38e6f5ea2f33c7c94482aa068539704db52fb5011fe7d74411cc0ad"
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

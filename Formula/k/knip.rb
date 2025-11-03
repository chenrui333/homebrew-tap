class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.67.1.tgz"
  sha256 "20bcf9f56711a27bc5b546ad8992de8a081a00214fa7029cdef859275f4f5d19"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5b19cc25eaf93e88010babcc4baebd963a6d304d709d8f271b0a300d4e9b616a"
    sha256 cellar: :any,                 arm64_sequoia: "04fa25fed97f375d4e88edfa4a2a50062e1883346ce290e02c94c34cad0e5ebc"
    sha256 cellar: :any,                 arm64_sonoma:  "04fa25fed97f375d4e88edfa4a2a50062e1883346ce290e02c94c34cad0e5ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c059e7a1eab615ca8339d0f1b295dfc79854264c8a7501862c50aef0e45b7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16bb80be4e2011829a509e91b4df8330848b3f3c3bc72daebc3a4cc7771e2b57"
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

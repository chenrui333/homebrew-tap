class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.0.tgz"
  sha256 "465944747884f543adfa3bd79484baea2a923d90db53a6f51d7197780182522a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951f205c952ffca355ba73e0b57433ed08f168de5b202e2ff31adb5c4d0f85a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f791432d61fa5d915263521607cfe0c46e24daf48723fb7e61a34ab9f74867"
    sha256 cellar: :any_skip_relocation, ventura:       "33bee8bf4a591f5f54f90888213728c878b9bb816baf4652b06476a4aad38797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc721feb8f4aa459af0a451f08d4b619e3e0ab870b5fc9f4d8ff6431d3295c6c"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.61.3.tgz"
  sha256 "f883fe615785ce51f8ac676303256743d3d4c80966ed3763500bf3be926eb6a3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "549ea4a2d36e73713031da8cdd7aeb4f2bff3345a8442c2fe7db6efc4275a94e"
    sha256 cellar: :any,                 arm64_sonoma:  "df927922bb6c5a0f70478e5458deaebc079ce0731f4b9c2089fe2407015e324b"
    sha256 cellar: :any,                 ventura:       "c243f718031ade36a5d13f75a04f5007eec101cc8956f321485639531cf03973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f27288487de8b954d4b4f630c5788372ee21b26677eacc8cac49128508d4a68"
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

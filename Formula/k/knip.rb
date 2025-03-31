class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.46.4.tgz"
  sha256 "a906561bd3500786443dc6c5abfa68653184bf09f7db0071e76099155f8e8e0a"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4b5f7d1582468fb6b8427a500b32b8eb41da9a6328b4c15d1e27c9cb47cf80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec1c98978dbb0c8ae35a37d254bd222018e34c329404a91419a9e5da59aa85f"
    sha256 cellar: :any_skip_relocation, ventura:       "2d7f9721c7d873906ca61819a7d4c31c3f3b6169746fff50f5fd6bd1230beeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99814b624f5427009c401c103b83148799d13985192b0e93b70e989ea6241fd9"
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

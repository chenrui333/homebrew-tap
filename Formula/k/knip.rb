class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.4.tgz"
  sha256 "d01602867389ec3e64df406127afe2f20bf1453733564539350e1f84e9d5adc2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6bdd7923a5620c63a6cfd8fa5464d2f9755ca4e88d39a422c541dc9f8eb7f83a"
    sha256 cellar: :any,                 arm64_sequoia: "638ab50df4122ffc9c0a2849d52de51541b5f102e3555ddb8ad5d51cd1265d62"
    sha256 cellar: :any,                 arm64_sonoma:  "638ab50df4122ffc9c0a2849d52de51541b5f102e3555ddb8ad5d51cd1265d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7feac4769c4b254975a487e507cbd6ac37c997e81211bd9cb58fd2008a35da8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3797eff9dc8dd028a4a1ffa98023d9a4ddb44bc99217564e193f7f7f7bf7d1a2"
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

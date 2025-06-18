class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.61.2.tgz"
  sha256 "1c31f1b783204f08f35344e4b5cc2c9c66402fb557acf8dc24079cd552ddf3c3"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "489f56354b94481063a9dd0ade6ec71c6403e6d21062045371360f6251b5d934"
    sha256 cellar: :any,                 arm64_sonoma:  "98ba6633b5338fe63d854ad8ac813dda7a472b8a9ed8e68d603c0178d129b3ab"
    sha256 cellar: :any,                 ventura:       "7de8f2f2d1d9fdaed876234b3d724a36998fda695f6b8c435813b7ca517b825b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da36b89dd1b4f7594046f632faba11b90ef0b70d7d835c5c6d215231560d3304"
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

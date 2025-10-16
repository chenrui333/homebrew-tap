class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.66.0.tgz"
  sha256 "bd8da2795f787eb25e6848a9868fe1d51432145063b8f5f25d3d332151c4bd31"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c1531617b4d5dfe063f95b2f88a9ac076b71948681f38ef0c57b329ec829481a"
    sha256 cellar: :any,                 arm64_sequoia: "b86f32e1a09ac786fd7054e719f4cfd1faeea51bcd5398b0ee954fb8780e90d5"
    sha256 cellar: :any,                 arm64_sonoma:  "b86f32e1a09ac786fd7054e719f4cfd1faeea51bcd5398b0ee954fb8780e90d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66713b0b2c9eec1eebce97ee97384a71ce7d2d5f5bef2aeedc880b56f0e44170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee01654486218d67d73050c7e89e12bba9c212ab45132811439bfce821eece4"
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

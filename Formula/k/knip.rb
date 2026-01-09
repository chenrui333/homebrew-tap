class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.80.2.tgz"
  sha256 "063df0ad6da18166e431ed619aa60c8f5f1de4df39dba85e747325cf5d9d04db"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0e88bf553c0c92e28069a580bf9e6c8161e75e4bacfe0f2d6ad04ba9fce02f2a"
    sha256 cellar: :any,                 arm64_sequoia: "1fee165d1ac9779b59a788cd6409c3fe3205f55b969c4b415d000b704860cb94"
    sha256 cellar: :any,                 arm64_sonoma:  "1fee165d1ac9779b59a788cd6409c3fe3205f55b969c4b415d000b704860cb94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20711252346c802bd43f70f42a4c6ad2a65a08a4db8a02badfcbbb8b1f5a1061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d506ad383836d8b7c21721f7cb980004322eae2898f5e6ec68f3bcd3d25b254"
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

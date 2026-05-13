class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.13.1.tgz"
  sha256 "1c695c79e4b8a278a5c11e19caacc36e5e4b0e4fa1e5875a93228b577d78f63b"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5daf776124f8f5815add1936c7e2649009517333facb3a7882e64c9c1e758278"
    sha256 cellar: :any,                 arm64_sequoia: "af7e01cc924333c93282cb79f10120f72790a124f249bab9adc14c2de08f7014"
    sha256 cellar: :any,                 arm64_sonoma:  "af7e01cc924333c93282cb79f10120f72790a124f249bab9adc14c2de08f7014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e693e4a6a4cea94e974e4a5bb1aa20d7c3e08ca7f1e2a01d2c5282c08b255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10a96d924f7d965275e12be2497e412af7309ea3ec1fe6b92775dc69162df79"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

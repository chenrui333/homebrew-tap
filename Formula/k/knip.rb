class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.1.1.tgz"
  sha256 "f017a3eecc79286c2715f3c78f38a7d5cf1b712c0601048f83e61bc98ce2db07"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "47929061e101c1f648a04d541c30f8b5fcae858fc00c030fa9d8b10cd8b0b602"
    sha256 cellar: :any,                 arm64_sequoia: "6baf925554bae734e0dc5d4e1eac2e884a3be2965eb435a784cfabaf427856c8"
    sha256 cellar: :any,                 arm64_sonoma:  "6baf925554bae734e0dc5d4e1eac2e884a3be2965eb435a784cfabaf427856c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17419ce73f7bcb46ac675a14aec9ac4635ffb217d6d4029ce4bf207f29fe543d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727e1628dae2aee4d3b53419f22efec8cc95a998db761e9a7716bb4a33bf7423"
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

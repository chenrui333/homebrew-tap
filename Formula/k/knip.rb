class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.84.1.tgz"
  sha256 "6573e7e851023cbe93d57d0967ed386a244bf18d65471d097dbc47df30125777"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "43e99364907ce2bd63ce700a48c12e191dd9de8fdb35f996cdb7274f0c3137c7"
    sha256 cellar: :any,                 arm64_sequoia: "488e902de0ac02f130d774b53ad94109ea6802993e14b3bf3de83f4b965d67c8"
    sha256 cellar: :any,                 arm64_sonoma:  "488e902de0ac02f130d774b53ad94109ea6802993e14b3bf3de83f4b965d67c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ad5c3b331c8806462d1d0a2cba4583b42b6de177d00feb26c0ccbf2487191c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf034880bc3cab2afd698778a7f5eb558f7f942fde390febd9a3f062692de7be"
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

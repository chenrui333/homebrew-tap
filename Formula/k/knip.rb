class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.20.0.tgz"
  sha256 "f064e8abf8394813f317599801b504d39f52bf4c68d7935c61bc19a384bd3b3c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "aa410c36f93d2b158e8fdcea02297a96dbbe8f778367ec3d348213ae255d10a7"
    sha256 cellar: :any,                 arm64_sequoia: "371af8e8b524573b91b8df0650be1046c7001d9233dc41880f8f81011f276925"
    sha256 cellar: :any,                 arm64_sonoma:  "371af8e8b524573b91b8df0650be1046c7001d9233dc41880f8f81011f276925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f0f99e7e187a151bf1afa38e473bdcd38a9d65dad74f4244162825628633079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de38ad93b3d65e66e00999e84c710f25842fc5bc66e8ae71b59c84f51832099"
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

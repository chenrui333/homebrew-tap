class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.0.6.tgz"
  sha256 "0645c6b1fba38357cb91a369cf932727a16df709217d94d11a71cff6f21b90fa"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4c59f06cd70cdcfc81cf30b49334710d73ff9d8935868052ec8c3c889e2a6d46"
    sha256 cellar: :any,                 arm64_sequoia: "529d71a9788b27dc62c4feaed0c51be363a8b75acdc8d1704d123daa23d471c5"
    sha256 cellar: :any,                 arm64_sonoma:  "529d71a9788b27dc62c4feaed0c51be363a8b75acdc8d1704d123daa23d471c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0abb44ba0de5dbf629f10efb1c7f1662acb200cb71c5be45b4f4e03635797c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e727158dc7fd4d724d029d91718f9f663a48187d75c8d14746178d1c890ac44"
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

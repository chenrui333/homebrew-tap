class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.18.0.tgz"
  sha256 "eff729ca96b17408fde51bc6eab7dc17b8df1fa904babc95679876718d13b79f"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "57af727730f77399c27ab8e3f2cab01a4d07166d039b9273bd633bf4244862f0"
    sha256 cellar: :any,                 arm64_sequoia: "b021acb935d8b44d89d6222eb71b443ad11d024f3c921d474241c0b79be94b85"
    sha256 cellar: :any,                 arm64_sonoma:  "b021acb935d8b44d89d6222eb71b443ad11d024f3c921d474241c0b79be94b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eb2c9eef66431500f7dbe120c5495bd8307a0189ceb836401c17478e82fb740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a917ba82a4c5ba32a44260ac1ee95e5386b2bd4460b7d7be775c5b035fee5e"
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

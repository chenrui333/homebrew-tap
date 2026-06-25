class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.19.0.tgz"
  sha256 "27e41d5fb75451684da35292e03c86b32a3bd1847b32fdcdfbd381ead7ba1b2b"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "427a4e681560be674df8d8295f806ce07e697f1fdf6f2eea40363ea002b9f43f"
    sha256 cellar: :any,                 arm64_sequoia: "cbdb14d5d2acf565c7db8e7dc963a693d55abdd46932fd086ea24fb453e419c8"
    sha256 cellar: :any,                 arm64_sonoma:  "cbdb14d5d2acf565c7db8e7dc963a693d55abdd46932fd086ea24fb453e419c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859bdd7b9c68240cf157511d630847047c3c4d21e13f06e78204be4d5ac4a1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dcb0dc65ab9591279ce12c0749934cdba5f854d3aa2d7031d1dabc44119d749"
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

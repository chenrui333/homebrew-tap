class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.37.0.tgz"
  sha256 "bb4ab0126ea1af659c3aaf9ae5de57883d007f318bbb619a24ed7836dba4fde5"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "487f1b3af4b916df1129c4d3576cd6f165bb98329ef88b3de13bb841d21aa7d5"
    sha256 cellar: :any,                 arm64_sequoia: "487f1b3af4b916df1129c4d3576cd6f165bb98329ef88b3de13bb841d21aa7d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe9994b3b680ce3de8526373636a94ff37d59f8699fb52eccb3efcce358a7e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f0b4bd53f57cc6e7e3bac9aa8c05f724d2a1b23e302a5cd3d5f3b26051d5c2"
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

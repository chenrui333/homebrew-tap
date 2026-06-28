class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.22.0.tgz"
  sha256 "59d3d39c5dff64eb2c5c5147556c93401980034fec18cfe35eee64d73e8e95b6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c761285b30de8569a4e606087ce596a26560e85139fe1cbcb234529e99339546"
    sha256 cellar: :any,                 arm64_sequoia: "7cad77dca1aad874eee136f35018c6d0a56767c2ea7dc86ddc53a3034a1d8af8"
    sha256 cellar: :any,                 arm64_sonoma:  "7cad77dca1aad874eee136f35018c6d0a56767c2ea7dc86ddc53a3034a1d8af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ea2f183216426e75fe4d1983c4902690b7d9d2770625c852e0b7621fa7f023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aea3b5aa1ce22197c5cc01582a01cfedd3cdc09dacb14ab129294bcb718f248"
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

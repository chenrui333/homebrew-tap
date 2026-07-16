class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.27.0.tgz"
  sha256 "855e1af6f12568374cf3c342e2c7f9ed2a70dd155bd36cb9acfdb324da9311ce"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c4507645c5646e1b74f31761d578fbc74bc657d688ebaff58a2bda8c98ba0e58"
    sha256 cellar: :any,                 arm64_sequoia: "c4507645c5646e1b74f31761d578fbc74bc657d688ebaff58a2bda8c98ba0e58"
    sha256 cellar: :any,                 arm64_sonoma:  "c4507645c5646e1b74f31761d578fbc74bc657d688ebaff58a2bda8c98ba0e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1164726329e7d2616d240bbd0f347b1075d48908cafcd3f9ec3cf5fbb1b2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4c59f767ac50e1b47a4e0f3441c7af6aabb7f50add24e1a3cdc7a322d76c2e4"
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

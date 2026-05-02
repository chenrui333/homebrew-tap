class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.10.0.tgz"
  sha256 "3601afa480260f940e333824808fe413ebdc5b728440fa5fdf8fd0ba92b9e3fc"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c48d79276beb3e80ef532e35f3879ba5efdd6958d90e50b2a4e7efce9cb0b111"
    sha256 cellar: :any,                 arm64_sequoia: "dd25fdb03ce3b1a462ef98890015516d5ed00bf59b7096d5e33f26882f6aaee9"
    sha256 cellar: :any,                 arm64_sonoma:  "dd25fdb03ce3b1a462ef98890015516d5ed00bf59b7096d5e33f26882f6aaee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0d4511dd150f21125cf7cb29f793f6594fe86479c8269c7c8fb9fb67b1611a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71842d6e28cf348ae1af6b73da6f0d5419820148787ad189643f68ae7eb73b7"
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

class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.14.1.tgz"
  sha256 "6bd76195ef01aa5784aef5eb82bcd3d6e6f763a1cf11ab7206ae28b4e1ab36b4"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ced205d5705f7ea08dfe14d59382a07e6c1a56789ffc572fdfccc73924aa6a3f"
    sha256 cellar: :any,                 arm64_sequoia: "bd9de6d20b2cd8016ba97873012cac0c80a4de89831a05e5bf2729755ac9ca12"
    sha256 cellar: :any,                 arm64_sonoma:  "bd9de6d20b2cd8016ba97873012cac0c80a4de89831a05e5bf2729755ac9ca12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a7a49a48a3dc2ff0e92c02ff2c419e7fcd5d8af560752a38399f24140321459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4aaff3ab475e7da7f57129c0c5064e0473aa1c66045835a2737e7c5f79e4111"
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

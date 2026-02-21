class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.85.0.tgz"
  sha256 "3af197da8191ec63a1fb06d4f5837c62bb7e8f506638b05a8fd6dcf516864194"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "84c77b1ffec20fda48fe1a7c9ad188e05408161cf4b25b03d99cd12ed010f43c"
    sha256 cellar: :any,                 arm64_sequoia: "b1aba8c890df17099a2af20c264f1556e19deac84e291518702685354aeb1531"
    sha256 cellar: :any,                 arm64_sonoma:  "b1aba8c890df17099a2af20c264f1556e19deac84e291518702685354aeb1531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01975684c7d107f53ee8e3303e9ee491e4700d163868773f8050503dc7d91e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7be0c50386551df44740a32a894c72006dbdd2e4e03f0062cdc67027b73d11c"
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

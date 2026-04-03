class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.3.0.tgz"
  sha256 "36b8dbda1f5595fc423a879c75a34a6e04d90489b693b22682e1f279e5d9e600"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7452585acf8d8559949165b217b78b738cc3b8eb48426ff620e27120bfa9dc52"
    sha256 cellar: :any,                 arm64_sequoia: "3166beb964e7f627c840a3ce7a129a202159151f10b2e054c16ce0a111e29017"
    sha256 cellar: :any,                 arm64_sonoma:  "3166beb964e7f627c840a3ce7a129a202159151f10b2e054c16ce0a111e29017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ae30d34bafd32e02d885cd48226e6085c43e11c8af684ce0b66b6d5662fcc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb811d4ec54821e9e561dd2a9f153010b0eb90067d563dfe2507808ad3eef24"
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

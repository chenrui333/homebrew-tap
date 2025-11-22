class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.70.1.tgz"
  sha256 "c0a47372dafa7e6459194c5cf83a00f99c4724107dfc75e3f798090de2584f33"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "19e272c2ae765177e89a5757001027999051332e9501f2b17bc94165e81dc250"
    sha256 cellar: :any,                 arm64_sequoia: "d82bfaf0a4f37e8c8647268ce64a7141155f52bbb922d21c7d5bc9edb5564b60"
    sha256 cellar: :any,                 arm64_sonoma:  "d82bfaf0a4f37e8c8647268ce64a7141155f52bbb922d21c7d5bc9edb5564b60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efe41f88e46cde2d2eb52c0c1bb8541b811795e087d94b1c6f925f7250f277f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2219863d841f59f500b1a467eca3b58cfafc66286207147ddb028cfc28894d14"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

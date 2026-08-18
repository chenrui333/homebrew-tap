class Chanfana < Formula
  desc "OpenAPI 3 and 3.1 schema generator and validator for Hono and itty-router"
  homepage "https://github.com/cloudflare/chanfana"
  url "https://registry.npmjs.org/chanfana/-/chanfana-3.4.0.tgz"
  sha256 "13aa3414cdbfbc1c9e6dfc4f56d11813c75d555ab8af7393b0f111a99297d452"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5fca3f857b73187837ef092c0e974d9b6c7b107b54be66f7842af8432ae6092d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/chanfana --help")
    assert_match "output", output

    output = shell_output("#{bin}/chanfana -o #{testpath}/schema.json 2>&1", 1)
    assert_match(/wrangler|entry-point|worker/i, output)
  end
end

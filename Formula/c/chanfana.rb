class Chanfana < Formula
  desc "OpenAPI 3 and 3.1 schema generator and validator for Hono and itty-router"
  homepage "https://github.com/cloudflare/chanfana"
  url "https://registry.npmjs.org/chanfana/-/chanfana-3.7.0.tgz"
  sha256 "3f14766050764ac6c6eb960a3003624c75b0ffc9e63c9320c3e897bf74596676"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ca10ff35db69f66d570ba1d50039b81af5ebedd56ebbe03f63c15394d786cf68"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/chanfana --help")
    assert_match "output", output

    output = shell_output("#{bin}/chanfana -o #{testpath}/schema.json 2>&1", 1)
    assert_match(/wrangler|entry-point|worker/i, output)
  end
end

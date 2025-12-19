class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.75.2.tgz"
  sha256 "e3f78f5bd3a7522ecb288f2717b58ced2c902d7ac8be0460543b190009608628"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6df2342ee2a1b605ca1757be581b0c45cf6a5535f60620c93e27267f1d03617c"
    sha256 cellar: :any,                 arm64_sequoia: "c869cf0d74e26f7210aecdd73862364be9929d0ec8704a490c26634722cd5f08"
    sha256 cellar: :any,                 arm64_sonoma:  "c869cf0d74e26f7210aecdd73862364be9929d0ec8704a490c26634722cd5f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dcedbcf5be3f75d54b95f394101d9d7c3f7593ddb6f6e1eb825f08013a3e839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d46e9014e06f5b6b0c0fee73114ee77d7438c91ddbf3f780f91d83fb3ec65fe"
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

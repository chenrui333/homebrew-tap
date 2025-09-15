class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-3.1.0.tgz"
  sha256 "e8e6d09b56b003726271af4a4665c114127400c4cc4f9ece4ea62f59259c7420"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355f7feaf016b26a2284d07f7683acf58b0a2a5be8d3d3cef9e9e6881daafcbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5eaa328e361f0df9faa344f4fc80a5eeb7e83f583a74180c4d55cf10cc57a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847843218ca56887899ef933ec7efe50b30c85bc6e16255dce715af78a0e42f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/secco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secco --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "description": "A test package",
        "main": "index.js",
        "packageManager": "node",
        "scripts": {
          "test": "echo \\"Error: no test specified\\" && exit 1"
        },
        "author": "",
        "license": "ISC"
      }
    JSON

    (testpath/".seccorc").write "source.path=\"#{testpath}\""

    output = shell_output("#{bin}/secco test 2>&1", 1)
    assert_match "You haven't got any source dependencies in your current `package.json`", output
  end
end

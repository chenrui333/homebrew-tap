class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-3.0.1.tgz"
  sha256 "8cb5b124d194773dfecfe687e958a7143de5c8af3610db6e81af835c126809da"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d51998e4b94d9d6ea08231be6eb9fcd2e2ad87dea82083f8227bfa0d9207c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad73c6ec834997982d72ea3e1b116a5a12b1493f3ee5c98cb79e2cddb303781"
    sha256 cellar: :any_skip_relocation, ventura:       "adaede800d38a88e24caeaa6e269ea894ad3ec0c299ddd23cdd21e22e91fcfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1942180ab44f3870c19980817e03049eab1fc5b1ae1067a98108364ab17c2304"
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

    output = shell_output("#{bin}/secco test 2>&1")
    assert_match "You haven't got any source dependencies in your current `package.json`", output
  end
end

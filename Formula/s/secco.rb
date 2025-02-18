class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://github.com/sorenlouv/secco"
  url "https://registry.npmjs.org/secco/-/secco-2.3.3.tgz"
  sha256 "910d73a2ad217a1158f7c97220e4e2c01cd60680e5b3c2bc5369f9fdea49321d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d1fa1d57ffbaae0cfc143bfcedde52f3423d44681347587f897af5b9f1de45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e50b5e67ed85536c2f01c5f41cab853765161de057d739273a809b48db6972"
    sha256 cellar: :any_skip_relocation, ventura:       "e27d411389b4a5d4588887cb5b68293e69ebdeb75c1d578c12187a60f99ca8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ebb21e57857794a544a9277851a496fb51aaebf4a1f8866d61f8c689588975"
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

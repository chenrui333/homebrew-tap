class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://github.com/sorenlouv/secco"
  url "https://registry.npmjs.org/secco/-/secco-2.3.6.tgz"
  sha256 "c174d2d7ac994bf7034f969eadc7503268c19da539234adc7efba0f14c9b4261"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ddc544dfd14d20afefd6ee1ee24fda9817c937659df5ca34d3cdb7b4c579bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3d53c5b24cb023aaaee21f51a220635a5afb54460a028b117f29d09a4c009b"
    sha256 cellar: :any_skip_relocation, ventura:       "0c81536b03059f84a9cbaaa619c0bcf8d8ac7ff3f40119da838389bc00c89e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24105d023b91c85dd473a804113172c35e06293c10af8e877809036e2d181fa"
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

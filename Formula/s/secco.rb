class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-3.1.2.tgz"
  sha256 "54c7b9e12cff9abc0f33405780c5f54d49e20b940456e01430ba2f336615c2bc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda34125a9c3f566aecfaa13ae10a1fa72eca67264824baaff11cc0807246fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b3e3be46610e927059dcf88fac26d3659b3587ea576a7f49c9504f16a324d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf0abb1945ebaaa2ffa6e552db3da7cdf8e3e5cab882719b511ca9048bed2b3"
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

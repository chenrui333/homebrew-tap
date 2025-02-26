class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://github.com/sorenlouv/secco"
  url "https://registry.npmjs.org/secco/-/secco-2.3.4.tgz"
  sha256 "b893b7a1133b1ca21ed284185492bfe5ca582b9da2525d740855a6ca7e699726"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb740030c595821b949550b0db96e18a465ed4360d800902c0fb93d2b028904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056f563c02573ab9da8367185b56b454491105f3b0589a2d60fcc5f96f8d32de"
    sha256 cellar: :any_skip_relocation, ventura:       "81e1c6193e712bc34cbe6c3f882e72c5fe527e9760282e1b7de0918d5204d616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5764df42a791b1df01fcaafd0de0e43643a1646474b8da573eb700ca9f26ae8c"
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

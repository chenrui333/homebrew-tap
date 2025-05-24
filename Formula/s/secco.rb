class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-2.3.6.tgz"
  sha256 "c174d2d7ac994bf7034f969eadc7503268c19da539234adc7efba0f14c9b4261"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9f0104c754c0378fc97b0657f99dc183e922c0b0ec17dbdab22af889a19e9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7589c6f78ae4a1d41dfcfa571b6f873f89c22e013c00d812c117d3a173ef69"
    sha256 cellar: :any_skip_relocation, ventura:       "e784881be7c0495cd020efb4201504ca9cbdd4e919696feb47c4d3d224932258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62f0cca61f79b045532dec69e578136990e775dfab604bbb8d09beb020a8e6e"
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

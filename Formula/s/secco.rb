class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-3.0.0.tgz"
  sha256 "c820ede5a7fd84955760e54b08424d3acfa1aaea63d707b1affdcb3283b83277"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61732c740badfadad91c726d0e64787dab3a7c6a84a1245f1d24e84d979c0c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef8c539769e7bc80425ba537798575869c8458ae58db2b67263d33841b65d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "e357de9add7422e2ad5dfb967631347a8876dd57d7e0e350384b74c10e15765a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7f347d4b7bdea6b80fd7a133387aa4df27fb4c88525c1877ef988a00a2cec6"
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

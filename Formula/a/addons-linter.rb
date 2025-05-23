class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.13.0.tgz"
  sha256 "465faac15bc050894113b57dbcabf8abcc63240366f309c94f4bfab07eb1b414"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a26c7e674e497cffc3c7495915bbf6907cb336f94a3c3b5ab472539a7c0ff56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd92342685367f3ca6b1fb011e02a2ade132c07b53e4aa0d6ed367836a6995e"
    sha256 cellar: :any_skip_relocation, ventura:       "6a5c2fd81c2449abd4d4e48617ef847e66bf7668ecbddd3b16bdb71d650d7808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192b9013ba8f46c95acf9d489908234c445bf6128ad897048443cc0592595e47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/addons-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/addons-linter --version")

    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "Test Addon",
        "version": "1.0",
        "description": "A test addon",
        "applications": {
          "gecko": {
            "id": "test-addon@example.com"
          }
        }
      }
    JSON

    output = shell_output("#{bin}/addons-linter #{testpath}/manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end

class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.13.0.tgz"
  sha256 "465faac15bc050894113b57dbcabf8abcc63240366f309c94f4bfab07eb1b414"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e0a367502d5e03e2c3cc0ce705ecde9bcc87e6a4b34239ffce810411b646bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "075c2cc90dc9258821045e59bd1d1428e19155ca3cc394d00eadf352b8a744ba"
    sha256 cellar: :any_skip_relocation, ventura:       "b15db64d26b4eced26aa3cae69aa84988734c6a440e0f72965c8c33077151c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e517e4d2cd85e2792dfb9e91aac6cb07a2d339c2447688234bef1ed62006c7cd"
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

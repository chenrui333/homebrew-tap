class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.11.0.tgz"
  sha256 "85107e898f369a0100092d0ee344f51144b7bc64cc21b93a2daa50d1312b54e9"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690a79cfac9c694de41b66f72c413d11a114109018b5e28d332aebadae40fc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e467b2da7048e0e4dd6826eeb109d5d66ffb46a9ac369f27e739d1a93e81877c"
    sha256 cellar: :any_skip_relocation, ventura:       "024cceb4eec1f749294b9dd9a799cabb3293f249c6e523f1f195513fb2f0e31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac99f08bdfacb4d43ea65a5cde77444f399b07d184b0d3a4053a819b48ef20ff"
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

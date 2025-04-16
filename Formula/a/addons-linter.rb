class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.11.0.tgz"
  sha256 "85107e898f369a0100092d0ee344f51144b7bc64cc21b93a2daa50d1312b54e9"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71282588787216290c6ea78ea500a0968bf3d745702a9de0da18233ea5b15ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d27036349efa4ca4bbd986b27f839ef51fa9ae2faab1d4fdee5d9fb36cf807"
    sha256 cellar: :any_skip_relocation, ventura:       "3ee2b6e66cb45b0ba1d70909ff71cf31d9860ad4da9544e7f317784745e4dc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77b11501a9e1235893b350cb4f2e096404550d79fb82e18987f65066931b259"
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

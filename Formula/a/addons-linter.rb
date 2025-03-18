class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.9.0.tgz"
  sha256 "4af78e2467765bb15cc9c4413efef141428cedad932dd526b867b0ae936b6d59"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bfe330b11b12f41a6266bda414b1610c0378d418f08d6d2af56f0c592f4b35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e4cbaeddc1ce629e630e7c00bd840ee34b0e62a1612a43528a6ff45a14d336"
    sha256 cellar: :any_skip_relocation, ventura:       "ba726591dc201976ea2752368b29262d1bbf5740e2c9392a14e2739bbb6b772b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b884cff8d4221d3be4135e1640e9f4ecf6b19631073b13fa53b4c3009fb7f71d"
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

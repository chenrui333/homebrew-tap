class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/sorenlouv/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.9.0.tgz"
  sha256 "4af78e2467765bb15cc9c4413efef141428cedad932dd526b867b0ae936b6d59"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ffb2db8937cae57efeed4410e8f2be546e99b42979ba88d1a8c05096e5781bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c047690b5e4c8769a81565251fc7b35ec7fbb102a8ae43d577d25c29e39b686f"
    sha256 cellar: :any_skip_relocation, ventura:       "05636896a02f9218b2de69acf9c3b39a964f9bf39c46524d668c1f2d0072401d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b118a9ff3ebce3a583a134657a6b862b35a0a7cccf345355a68f63581f1faa5"
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

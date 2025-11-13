class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.33.3.tgz"
  sha256 "6b030f201639cf456a1cc639694c2683359821d56d32078347ab399ac39ad49e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a5d7a5b9e311150bae3e93e528095bb925f36a66e82c25fb7dfe996fc7b34ca2"
    sha256                               arm64_sequoia: "e8093068d1ad033ef2ab6cf4f4dbcdb8a6877760378c6bed438c9ce42ea9c233"
    sha256                               arm64_sonoma:  "ea62099a3d91e902a6963a5edab971005fed3302be6a42cdb7e11202c508f023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4744374102c11cd762d64acc3c922905ee58f04ec80c18168b50208007fccb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "287d2a87f5a826e207d1f88de1242e412fee897a6b05d7ca0cd737a7489c067f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    if OS.linux?
      (libexec/"lib/node_modules/@clidey/dory/node_modules")
        .glob("sass-embedded-linux-musl-*")
        .each(&:rmtree)
    end
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end

class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.49.0.tgz"
  sha256 "935928bcb1cedb3cfc8b6dc753e726c4556a55c82afc3a6fdafd87d09456b437"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "03f4e04bcbe150fa5217322f154d99d95c0023e0d9153f90b006166dccd2c974"
    sha256 cellar: :any,                 arm64_sequoia: "03f4e04bcbe150fa5217322f154d99d95c0023e0d9153f90b006166dccd2c974"
    sha256 cellar: :any,                 arm64_sonoma:  "03f4e04bcbe150fa5217322f154d99d95c0023e0d9153f90b006166dccd2c974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a200caa9df11fad095f7ceaed8d20b10484d5b3c7ae15d27f688583711600ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462f41003e6f16de84a92e3a77c413e9fa2ce9f63e4eba2487eec4bf18de5ac9"
  end

  depends_on "node"

  def install
    # Use the source-built JavaScript implementation instead of sass-embedded's prebuilt Dart binary.
    inreplace "package.json", '"sass-embedded": "1.100.0"', '"sass": "1.100.0"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end

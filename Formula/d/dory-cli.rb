class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.46.0.tgz"
  sha256 "c3c9b583d95d371eafc7d47f413346f48ea4365cf894bdc99a3955e5b63c3fe7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bfa2461211ec3f23528c4e9b87537209a7de8ec9769ef4cde2dcce2a3feded3d"
    sha256 cellar: :any,                 arm64_sequoia: "2fd1e1934ab0ddb922baa0ecf31cced0e7adb93d2bcc6393f8daa5fb4ec3bb86"
    sha256 cellar: :any,                 arm64_sonoma:  "2fd1e1934ab0ddb922baa0ecf31cced0e7adb93d2bcc6393f8daa5fb4ec3bb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc1988f8783c2660f718bfc57a806bff45643b3583c206326c2e92e279de1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ba3277d3da93c8b391a450e6e501f3808563559532fc2a82d5597c6152402c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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

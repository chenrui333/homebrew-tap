class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.41.0.tgz"
  sha256 "43d0bd98f3798d748efbf5f369d211794e64f5a301d3ccbb5252793729dab5aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d5b45c01565db683755b0d7ed0689a6eb0a8693427d47b0eeba35b25decb60d6"
    sha256 cellar: :any,                 arm64_sequoia: "e8d8bbc02037888df57e48fdd9b3dae45da02570b3a7f8b2bf304bf88047f0ed"
    sha256 cellar: :any,                 arm64_sonoma:  "e8d8bbc02037888df57e48fdd9b3dae45da02570b3a7f8b2bf304bf88047f0ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6da1c21846669b56f22bfeb5161da838d2562b2351a8ac180f28a543d9a80ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c7eb69bac04dbd89961230958f719ca769d42c4f86b788cfa2104b30886c53"
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

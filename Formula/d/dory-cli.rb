class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.40.0.tgz"
  sha256 "d60c0843ad06ee29688c23174d59843a3bc755065068fac79d4c64ad29f2836c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a25917704b6a497817540abb85fdf8786e33ea1a632fe0b9ca42383f14eba0d3"
    sha256 cellar: :any,                 arm64_sequoia: "6b606d962f94e778bbde36266744945a97a79e23b5a67745889c2381412eea57"
    sha256 cellar: :any,                 arm64_sonoma:  "6b606d962f94e778bbde36266744945a97a79e23b5a67745889c2381412eea57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b51f792a4cbc3440738f440e064ddd65f1ada04b64b8055c60ecf903ae2440d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26028993764195c260d01da4a8675aff1f4bc4f12e313af672145fb9eaaf69e8"
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

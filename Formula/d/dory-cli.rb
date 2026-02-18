class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.40.0.tgz"
  sha256 "d60c0843ad06ee29688c23174d59843a3bc755065068fac79d4c64ad29f2836c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ead54291c03bc4269ad87fe6d7db7d24b9a50bc03c2f4410b1dfd3b2193ddc32"
    sha256 cellar: :any,                 arm64_sequoia: "3aa0e4ede8d6c5952b8bffd74f635b4ecd6e52805127c70c68626a028126baa6"
    sha256 cellar: :any,                 arm64_sonoma:  "3aa0e4ede8d6c5952b8bffd74f635b4ecd6e52805127c70c68626a028126baa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e083b9496d9365dd35145c9d8965d4b85a7b9f7f1aa75519ce8b583e6c882d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c8b4ea142bbec06fd8a06273357d58e052c3ac8d96d222a403b5e611aed1d5"
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

class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.27.tar.gz"
  sha256 "bfc619bac91faa6efeb7d09ac9e2eac2f073b58a107c25c7018c6e19fb5f52e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d0f503ac505d4b833d9938ebf6323a2a844f78934612eebcde116865ece4dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210fc81e3220c963c34111cafc7211ed4d1ec3c06653a6dcc75c7f5ec162d18a"
    sha256 cellar: :any,                 arm64_linux:   "461486ab1fe004c2c3a6346b81719a680d434818aaca25bf0f2dabc9cce7d088"
    sha256 cellar: :any,                 x86_64_linux:  "eff50de3ff659ab485efe1849e253db948c3f1e5d2ebfab8592caf8ef5e75770"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")

    ENV["HCOM_DIR"] = testpath
    assert_match "Set:    hcom config terminal kitty", shell_output("#{bin}/hcom config terminal --info")
  end
end

class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.25.tar.gz"
  sha256 "f3f4b0b7b771ac5ae5dd8344d15b876de49bb7307c9b2cbaa4778d9af1bf555a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ae831ddbe70ce7852fa241cb9f853edd5951e69c92813f30ceefc09a914814c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e53712b048b004031d08380f4e2f3def862df5d6ce194824470c06e20fbb66b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2ba7ed4cabb5efe0e6f81a2d0709f5494340c4f9235823e14da2d736d0f905"
    sha256 cellar: :any,                 arm64_linux:   "baf7754bb8ccb4e7db628362cd3321c183cf7b1d59d5edb2d13afe2e5f774534"
    sha256 cellar: :any,                 x86_64_linux:  "30947122c12dae9d0989658fff262dc8da42e3e8e937e139eb868c8768da6838"
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

class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "5c4ad2e72778eef778977c7c617a324b07d671d1a12ddd7d59880c4d1c8dc7ce"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ffdd8399af3f2150286a3f04206949cbaaebeb67aa37f8c1e1769ea9241cfc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb8eb376a730dfa5197bca78e63178f9c73ce825e34aad18d654a4b58a24f4f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496ca5d453e101a246ae6587c913f30704ea9d93aa96020c250128b8e70fb128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bbd0690530e5695383c0b0a39d6fc5dbd1fe39ad43a74de622fc79664237ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3da7dfc0170161786f8803d32ccf2d7d4d9994ed72d4889a2035f729468d9fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Condition:", shell_output("#{bin}/rustormy --city nyc")
  end
end

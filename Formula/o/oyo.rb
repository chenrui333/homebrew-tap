class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "8b98da1b3dfb0f65024a2243c9c8be694febc3626e2be13432ebaa63055d082d"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "575844b57f476c2eb25031ba43c3450881d6cb59907990a40099e867ca1336bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7080d1fa9277c12a35fd74bf8a89dfd2f357208695ad69786c6e4d30c7843e82"
    sha256 cellar: :any,                 arm64_linux:   "b9f5b8488efbbf3245b184f5be6b56e7603cd7e966fde44d02fa1cdb6bef70d6"
    sha256 cellar: :any,                 x86_64_linux:  "721864e58b0b11f4e954504a004a02567e26db11dbd8ecbec9ef438110e6cfe2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end

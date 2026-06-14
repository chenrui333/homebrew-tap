# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d06648feb9d0da53f10188f050e8324162a1a83a1ed0f2f7a360983dc2f2b0a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3274ef1115f0d94f85ec3eb271aaa431e2b6c2726fd4e23cff37e2f15d7c6458"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26936a43b4de0b37d0421a67947c6c9c2f3f508fc12534fd4ead2215b1199db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ed707bb3d9bea8eea133e2bb40f1cbc23a1365bff2ddf42e0ca0ecd41e376a"
    sha256 cellar: :any,                 arm64_linux:   "872e12568f51d4c7bed278c98ed87deeaab6790797ec632782414c73290d0e67"
    sha256 cellar: :any,                 x86_64_linux:  "5c9bc51f6b6128b22c58ed134079557aa4cf6c26a77d8a703890e377e8084a8c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tickrs --version")
    output = shell_output("#{bin}/tickrs --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

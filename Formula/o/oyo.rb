class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "8b98da1b3dfb0f65024a2243c9c8be694febc3626e2be13432ebaa63055d082d"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78618cadf48424bb629e9417c477a585fd1ed392b883754d71865253d1e8218c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2b6282b194d4560a4dea4acb7dc869e379fd0293b26032cef6769ee2a25392"
    sha256 cellar: :any,                 arm64_linux:   "93929006abcdf052902745bc9aff015b82bde6b693d93e30b10749daaa39bbc3"
    sha256 cellar: :any,                 x86_64_linux:  "9400a8db3302697c051cd1f09f33a5125634859218435c572985a214b59b4b1e"
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

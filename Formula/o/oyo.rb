class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.61.tar.gz"
  sha256 "4340cc723e1a78507bb746d43cd264f5f73c5844da842bcb73322b1e565ea60a"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc3a91f1afb44c79654960d15ea69d61e550977f8748070838f33a534d956f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b24ddeb49adfbc697ad7bcc05aa5107a6233bc1d85fd6ee9ab775747845a7b"
    sha256 cellar: :any,                 arm64_linux:   "9eb3042486a6dd84008254db9457abea792eefed82f94626cfc528024b56e9e8"
    sha256 cellar: :any,                 x86_64_linux:  "537eaac9fe006ad8cff877cf828e2aaf5e1aa0dde33abd4880c0895da023f48e"
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

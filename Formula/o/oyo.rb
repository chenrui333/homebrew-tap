class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "8b238bc783e5c1503f6de991198bc59078962ce52d2ca930043393fcb795cb56"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17faec41c662f0544f2a21fc50fa9787494d351e8c09738cdb422ffc03ab64a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adfdd560c79e00cb8a974ce1d9d50a21cd5a19ac0f37bdcbb661819e7dd323d9"
    sha256 cellar: :any,                 arm64_linux:   "060627b8b7fa4be6b4cb3198de5150e29578eef638650fc92282637f4f4b0539"
    sha256 cellar: :any,                 x86_64_linux:  "8d15f34b29109bf7bfaab282523631ea64d850267b196330588a5bd7777f0aa0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

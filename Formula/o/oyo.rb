class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "dbd35731f38e394ba6712446e74f7833a7b46ea4eccbfdcccbc6ef03c6d256d2"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a56aed0fa64e7fe0439c8d437e88885700d89633e8393c851d42c3b6d3fda96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c96d6fc330f7195d43c0582114dd2225c6ef5799f617df9b002d17d57ff3c693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62576f7c8003b7ac8e80f9322542e090fe316bc2de2d2a5ccae59ca770fbebca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9804e3acc08e8371474fef182800ae6f991468aa6240e6702f84af8963e2e3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4992c28e2201b0829539d511164a834a80b3aa192fc4e06b234653574d88401"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end

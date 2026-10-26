class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "0ba4cae185f15e302ab175a874c165a8f41a7e74b6365991253d46d6b2908729"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3cd13df520133906122bc741e72e44c119c08e7220f966096457cc4bffe0862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59074cd77e5ef7f7942a77558285fcca97919d97e2a721d1e6ef3dbf38ac7f73"
    sha256 cellar: :any,                 arm64_linux:   "a4e662f8c4ae95a3a9078ccfb2dadbe3450e6e81ff38e3f2737f8d0a33379e80"
    sha256 cellar: :any,                 x86_64_linux:  "c8ac5b7cad6151384479abc70eaec3d0a09ff9e7869f287ec5b009fc382fba4c"
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

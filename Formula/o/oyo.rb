class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "b6210a6821851df0745696def9edcc0d7d4ac60576c65b8f5d56a928ac663049"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fca914133a9d73cd3e6eea4047578eacc57a31579d4199519277cf4427f7d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935a6557609a4cc4c8fd6f9e4df97c2621ffc26e7dc9348e1a942614810b912b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb0d2249cffc09f9b9ceeec4ce537c351f151a129102d5f32f90523f1c2f37f3"
    sha256 cellar: :any,                 arm64_linux:   "cefa3999f5673c3cb5f04c5221e8bd3b933c1564b1a9b225597b9bd97cb7fdf0"
    sha256 cellar: :any,                 x86_64_linux:  "13f96c2ede41144a09ae106acfba0876e8f533113dbe02f9224d1f0373b5d64c"
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

class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.1.2.tar.gz"
  sha256 "74d329e4e247c3ec0f30c8134e4a27b64e924a7eecad81da19e9629b3a10cae4"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "937aa67a231a1ba65df5fda55968c78a8f4e6b7db32b7b4090c9924b9998ae8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "674b5393bb20c7dc6c346fc365724406383835f5f1d2e52334671b77122c45dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da2a347b4fe83a748fdfdf5a0eaad462a67354970899d59d63a6fb3ca0ccebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60b2003c455802cccc95072689274a5bd432f3eff1fa882f84fafc22489be71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9987828e6781f572c579fc8a2db66638184391c907e75292eeb60b2387d94e2"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    (testpath/"test.R").write <<~R
      x = 1
      y <-2
      print( x +y )
    R

    output = shell_output("#{bin}/jarl check #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end

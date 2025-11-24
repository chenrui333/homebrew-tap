class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.1.2.tar.gz"
  sha256 "74d329e4e247c3ec0f30c8134e4a27b64e924a7eecad81da19e9629b3a10cae4"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  depends_on "rust" => :build

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

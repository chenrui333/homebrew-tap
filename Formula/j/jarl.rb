class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.3.0.tar.gz"
  sha256 "1196ff7720ae16ad832573104daf41fcc67ee2ac1e4905f15fb57a3f6d878449"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea098ff641c1c3905987498f1b26feacc39afc6e39700d4bc5e98a8428f9f9d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0336bcb15e101c760c5e903b847f76cd64594b16ab5868e96a282badedf126ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e933b057e7ed4ef6c6743b3a28532e308fff796c06993486ae147c8ec212f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0351615faa71af6c8e5596e1c378424dd38568e64a3a1d6f096409a46dbbc42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21f4bb55fa5fba9a018c73323dc833fbd4e01113a2f2e68ed8a1ea5c3d5c836"
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

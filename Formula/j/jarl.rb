class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.2.0.tar.gz"
  sha256 "80a0ffb979bbb0888d81ba6abb710cafb7308c4ed411c098d49882001ba87fdc"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "804ed7c191abf6da636f0516aa695d9521658558bd95d9c61f1f0314a065b333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b82f0f24bad0179d919b2cd1dcf89e853f7c648c229ff9ea01a554c732893b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf2facc2a14de9cd35ea4000072821f6c5b3133ec1affaa0eaebd3ce6d9eba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "913b36c10ef18a63b6448a2af4e35bd0b064c6f06abdfd095597f5e3ba44f3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119e6dd101ba803e7c95f13218c052ea76a3cca2348d4151f3b3f06a8c057052"
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

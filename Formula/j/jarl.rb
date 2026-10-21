class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.7.1.tar.gz"
  sha256 "f1974b1f8082fcfa44b5e9a755e8787f9fedd6aac63147714a46a29b80d85ffe"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d407861fd9a0a802b1aee613ed07a62f0187cfdc0a34f5426b7093326c9c1ee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac07c13aace200e7c4620f1bb12233cbc6b75e5c1bbef765fa247a571b6a8b7"
    sha256 cellar: :any,                 arm64_linux:   "564867640473ad03f0b336e899d1f18f3a3aff484ff609071c0f05e6211c0594"
    sha256 cellar: :any,                 x86_64_linux:  "4d2149f49bb8b2e60cffddb16f9eb5faa17be039728db56ab39d515d11f475d1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

    output = shell_output("#{bin}/jarl check --select assignment #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --select assignment --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end

class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.7.0.tar.gz"
  sha256 "a70d9ab7396606797855832dd5c2661f59582d2b0d4a1396ff189537180a6150"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73815f76f58f0ca195404e742d830447f06214b61eec267ec78994b2c5fca3aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f2c71909b10e8328ac2fb360af28330a10d65c630fc80558ab74311795bb46"
    sha256 cellar: :any,                 arm64_linux:   "e3c8dd5e41f539cea61b2014d64bd3b2207bbb664c4613c6df7a97e574a85f2a"
    sha256 cellar: :any,                 x86_64_linux:  "94ce3b96103eb05437b14fbcde55a5a28146feaf3dd190743982a0b4f7b46cd2"
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

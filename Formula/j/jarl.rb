class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.6.0.tar.gz"
  sha256 "86620fcdb654d18be5f9fc62257ff577eade56cb1a6d9a3bc7d6e6857006a8a7"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9dc2b3f03b0115d336ea6bc0ceb3962f0ea0b5fecc84bd3d8ceba6a4051b61b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6467fbc93aa428f741cbe1273bcc848c15af8aaf8eca8080ab1e4fefb9bab9c5"
    sha256 cellar: :any,                 arm64_linux:   "4bfe8fab82137b570f63b705d129e0fd0dc6c5f451fcedd76be9bbbf0e10edd1"
    sha256 cellar: :any,                 x86_64_linux:  "2322bcf3e6a95c14ff62d4fe362996a32fff1660eb1a7629730b69f6c8602ee2"
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

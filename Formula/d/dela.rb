class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.5.crate"
  sha256 "03509398a70218c059f2a9d19d1ddeb717faf463152df95336db1ee1883c3880"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c938eecc91c376fca80c979fd15e247f0d52caa479e82cf33ac5f17a3a2c1259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c2a13e8dfecc71b7542f1bf93e70f64d77d1221ed412de30a6ce5df368263f"
    sha256 cellar: :any_skip_relocation, ventura:       "72de2fff249447b982ec3658a3fd8f9208843d723e210b86929cd5496c230a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f296b2849df4201ef49bc98a1b31d612d0d742464a9da60d1fa39a8bd162a512"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dela --version")

    (testpath/"Makefile").write <<~EOS
      all:
      \t@echo "Hello, World!"
    EOS

    assert_equal <<~EOS.strip, shell_output("#{bin}/dela list").strip
      make (1) — Makefile
        all                   - Hello, World!
    EOS
  end
end

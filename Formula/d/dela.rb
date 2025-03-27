class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.4.crate"
  sha256 "e83ea486f3e254644707052e89c1331a7542c95771b25c3cc18fb7a631d4e24b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8365093902e3c09f558f15ba7901166eccabdb376677dc7fb51cb74b12c670aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9ff1e6a7316c440032b319e1ab5dadb8cc87027619a1d5c4b0db71d38811f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "740a2778d6a29e4c072072ea0fff85b297d39bd71bc019e2f5b84ea18e429ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86afa09a1da6ff8b773421f7b00f245df7b2a5a3258169532b56b2b799f9af0"
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
      Tasks from #{testpath}/Makefile:
        • all (make) - Hello, World!
    EOS
  end
end

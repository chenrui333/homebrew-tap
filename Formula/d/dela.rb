class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.2.crate"
  sha256 "767edcc040a536a0143905791466035b6f6614fced56e5bc38dbd40c0a5d419a"
  license "MIT"

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

    assert_equal <<~EOS, shell_output("#{bin}/dela list")
      Available tasks:

      From #{testpath}/Makefile:
        • all - Hello, World!
    EOS
  end
end

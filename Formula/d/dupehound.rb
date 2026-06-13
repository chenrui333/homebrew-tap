class Dupehound < Formula
  desc "Fast, offline duplicate-code detector with history chart and CI gate"
  homepage "https://github.com/Rafaelpta/dupehound"
  url "https://github.com/Rafaelpta/dupehound/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b8915a13c7846a6da748914ea09aa32398f358bd9e07dc204a646437f29cf40b"
  license "MIT"
  head "https://github.com/Rafaelpta/dupehound.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dupehound --version")

    (testpath/"a.rs").write "fn hello() { println!(\"hello\"); }\n"
    (testpath/"b.rs").write "fn hello() { println!(\"hello\"); }\n"
    output = shell_output("#{bin}/dupehound scan #{testpath}")
    assert_match(/duplicate|clone|pair/i, output)
  end
end

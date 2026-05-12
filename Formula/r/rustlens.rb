class Rustlens < Formula
  desc "Blazing-fast Rust code inspector for the terminal"
  homepage "https://github.com/yashksaini-coder/Rustlens"
  url "https://github.com/yashksaini-coder/Rustlens/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b5dee233fc8f792b0e9577771d2264b7bdc918a7176cf4689ef866c3e963d94d"
  license "MIT"
  head "https://github.com/yashksaini-coder/Rustlens.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src/main.rs").write("fn main() {}")
    assert_match "main", shell_output("#{bin}/rustlens #{testpath} 2>&1")
  end
end

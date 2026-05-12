class Rustlens < Formula
  desc "Blazing-fast Rust code inspector for the terminal"
  homepage "https://github.com/yashksaini-coder/Rustlens"
  url "https://github.com/yashksaini-coder/Rustlens/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3c5729600ad797b1e9e69cae57ba3b60a617bec3f30c27c975ef9d32b70052e1"
  license "MIT"
  head "https://github.com/yashksaini-coder/Rustlens.git", branch: "main"

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src/main.rs").write("fn main() {}")
    assert_predicate bin/"rustlens", :exist?
  end
end

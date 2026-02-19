class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.8.0.tar.gz"
  sha256 "3828028f41c668caf02aa9ffc4dc3bd1a33b4957eb66a7aa015f7c92e4f064ce"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    cd "wild" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wild --version")

    (testpath/"a.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello, World!\\n");
        return 0;
      }
    C

    system bin/"wild", "a.c", "-o", "a.out"
    assert_equal "Hello, World!\n", shell_output("./a.out")
  end
end

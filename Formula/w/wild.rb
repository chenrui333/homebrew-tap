class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.7.0.tar.gz"
  sha256 "4e361126f564f721efca627a414759111d88b06fe26ed15c7604a6420cb9a8ab"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wild --version")

    (testpath/"a.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello, World!\\n");
        return 0;
      }
    EOS

    system bin/"wild", "a.c", "-o", "a.out"
    assert_equal "Hello, World!\n", shell_output("./a.out")
  end
end

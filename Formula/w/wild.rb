class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.9.0.tar.gz"
  sha256 "f70ac025d158fd2c41be8f895a90a8f39b8b89fefbbb8ad5f45441f57b80156a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6f1197d29a1387be69dd26241f53b1533bd91a54e0fb7895116ed738e8240b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c7d1e33a1c03601c918f952edeaff972b66440d05fdac608f3a5297d9901559"
  end

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

    (testpath/"ld").make_symlink bin/"wild"
    system ENV.cc, "-B#{testpath}", "a.c", "-o", "a.out"
    assert_equal "Hello, World!\n", shell_output("./a.out")
  end
end

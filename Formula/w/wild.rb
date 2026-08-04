class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.10.0.tar.gz"
  sha256 "99ec83404558d4d0cbde9dd44b8c6fa2a511a2f8bb04a31f54c0929ec4491990"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "89cbf094728869773d94324a1e18e1e5d2c579203a15f93d412ddd55a75f2f7a"
    sha256 cellar: :any, x86_64_linux: "a265fb2bdce52fa6f0e23d2c2cb01edb3b33c02a51e32f0d17418a783ea142e8"
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

class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.11.0.tar.gz"
  sha256 "34d0c66c70b3c4744c548b2b821180d2d578b86eb747cb4a9ed1f4b11a95b337"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "b602b04684fd6674743d136bea10442c5ee1bb819053ce2f94e9339ab3604550"
    sha256 cellar: :any, x86_64_linux: "4db14a4181f2f6d6b230d4cbd7399fabdf396cc7b7c2f67919a5d05909df1b85"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

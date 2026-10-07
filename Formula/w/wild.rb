class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.10.0.tar.gz"
  sha256 "99ec83404558d4d0cbde9dd44b8c6fa2a511a2f8bb04a31f54c0929ec4491990"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "c257acf6208acf34b43ef2e561c71ddd1c4fd8173b25edc6f90c74987205721b"
    sha256 cellar: :any, x86_64_linux: "e40c9001756bff70a8ff1a8e8a30f3004bff787157ef2e0a635dd35e672c66cc"
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

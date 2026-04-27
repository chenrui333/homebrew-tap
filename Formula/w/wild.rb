class Wild < Formula
  desc "Fast linker for Linux"
  homepage "https://github.com/davidlattimore/wild"
  url "https://github.com/davidlattimore/wild/archive/refs/tags/0.8.0.tar.gz"
  sha256 "3828028f41c668caf02aa9ffc4dc3bd1a33b4957eb66a7aa015f7c92e4f064ce"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/davidlattimore/wild.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f85bd8b77ed8cce31a7f3128ce3399bdb046fd4a1c32d5492356300bf3477bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52020f072419683889b0141657f35d629b2cbbe4f4b25beb40a30ab045de3724"
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

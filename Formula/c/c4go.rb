class C4go < Formula
  desc "Transpiling C code to Go code"
  homepage "https://github.com/Konstantin8105/c4go"
  url "https://github.com/Konstantin8105/c4go/archive/5bf367b9678adff0c634b0d6daddc58a1c7eb7c3.tar.gz"
  version "0.1.0"
  sha256 "32b887dcac33e2594d469a70552f9395cd458660478cc82f5f64b95817dea28d"
  license "MIT"
  head "https://github.com/Konstantin8105/c4go.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Konstantin8105/c4go/version.GitSHA=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c4go version 2>&1")

    (testpath/"test.c").write <<~C
      int add(int a, int b) { return a + b; }

      int main() {
        return add(1, 2);
      }
    C

    system bin/"c4go", "transpile", "test.c"
    assert_match "func add", (testpath/"test.go").read
  end
end

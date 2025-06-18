class C4go < Formula
  desc "Transpiling C code to Go code"
  homepage "https://github.com/Konstantin8105/c4go"
  url "https://github.com/Konstantin8105/c4go/archive/5bf367b9678adff0c634b0d6daddc58a1c7eb7c3.tar.gz"
  version "0.1.0"
  sha256 "32b887dcac33e2594d469a70552f9395cd458660478cc82f5f64b95817dea28d"
  license "MIT"
  head "https://github.com/Konstantin8105/c4go.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9803e2c2f34d7432457f671225e28f5504e33daff6696a255da467bc9b0b5e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f148fc2ea953688d2f2db4b071929b80cb669c079c3dd70f2c48b791b549271a"
    sha256 cellar: :any_skip_relocation, ventura:       "e152d6b291664d042c3337df23b9a89a36bf0a616b9abba087dcca9c8a83814e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b66add5b463015d55f2da20d0f9d693dadb6c9463e689da587e63b61969268d"
  end

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

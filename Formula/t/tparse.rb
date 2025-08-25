class Tparse < Formula
  desc "Tool for summarizing go test output. Pipe friendly. CI/CD friendly"
  homepage "https://github.com/mfridman/tparse"
  url "https://github.com/mfridman/tparse/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "11e779379e6605202aa1751b2de3e36179ad63c38c478748e8c4e4693845c1b5"
  license "MIT"
  head "https://github.com/mfridman/tparse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743bc92e051a1c986aec44c6e54e3fb39c1528bba10cce742fd1ec1689756880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedb76dce08a7b250a24b82f38882dbe3d7364205c16576637c44a03b8ec6d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "f637c6e042945a6d29ae567bf71dd83f772d56fa6439749ecf66a288b45efa0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77be2f1e1d99601c95ac5dc9705688b9ea1d534538d2a853c887de4dcc34264"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # TODO: need to fix version output
    system bin/"tparse", "--version"

    (testpath/"go.mod").write <<~GO
      module example.com/tparsetest
      go 1.25
    GO

    (testpath/"a_test.go").write <<~GO
      package tparsetest
      import "testing"
      func TestExample(t *testing.T) {}
    GO

    json_output = shell_output("go test -json ./...")
    output = pipe_output("#{bin}/tparse -all -nocolor -format markdown", json_output)
    assert_match "|  PASS  |  0.00   | TestExample |", output
  end
end

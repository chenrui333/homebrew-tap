class Tparse < Formula
  desc "Tool for summarizing go test output. Pipe friendly. CI/CD friendly"
  homepage "https://github.com/mfridman/tparse"
  url "https://github.com/mfridman/tparse/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "11e779379e6605202aa1751b2de3e36179ad63c38c478748e8c4e4693845c1b5"
  license "MIT"
  head "https://github.com/mfridman/tparse.git", branch: "main"

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

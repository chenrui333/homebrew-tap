class Tparse < Formula
  desc "Tool for summarizing go test output. Pipe friendly. CI/CD friendly"
  homepage "https://github.com/mfridman/tparse"
  url "https://github.com/mfridman/tparse/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "11e779379e6605202aa1751b2de3e36179ad63c38c478748e8c4e4693845c1b5"
  license "MIT"
  head "https://github.com/mfridman/tparse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9ef66e8b99f27ab0a528df8d8951d54242f2d9c0e6454200ed95e5743925e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9ef66e8b99f27ab0a528df8d8951d54242f2d9c0e6454200ed95e5743925e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5030c1b9a20d82b1800e0da74a1d70f805828281499ba35f26f0fb64f2fed33"
    sha256 cellar: :any,                 x86_64_linux:  "25529e554e634808d88f6a449d258e1288db6d1f9d707d66318fb2e8cbd19779"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

class Tparse < Formula
  desc "Tool for summarizing go test output. Pipe friendly. CI/CD friendly"
  homepage "https://github.com/mfridman/tparse"
  url "https://github.com/mfridman/tparse/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f4755207b178523096a592ff2b67d3142467938676d87d5b0f6a03d83e7be71b"
  license "MIT"
  head "https://github.com/mfridman/tparse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bb5fea8cb5122f12a6cfef133af01218d24da0f06976a2a6fa7b315986d003ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd1f3186980c328db627e7dba4bf3f73294e33f0cd7f9e3da1a2048760a62438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd1f3186980c328db627e7dba4bf3f73294e33f0cd7f9e3da1a2048760a62438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ca6e4961f89e41b8cc089b57c115ba8df130840b0937c1c71b586f2d7c0d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb351df61ee96d87d1b90984af359cbb719f7c8c4c5929db17fff9bd179614be"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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

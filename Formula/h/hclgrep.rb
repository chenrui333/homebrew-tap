class Hclgrep < Formula
  desc "Syntax based grep for HCL(v2)"
  homepage "https://github.com/magodo/hclgrep"
  url "https://github.com/magodo/hclgrep/archive/00059cbc78022cab225e172cc695c5edf1e4b8ef.tar.gz"
  version "0.0.0"
  sha256 "d6010eeb679e660ecd8612d5081ccc10a199482d266e01c530cbdd94bf6d666e"
  license "BSD-3-Clause"
  head "https://github.com/magodo/hclgrep.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.hcl").write <<~HCL
      resource "foo" "bar" {
        attr1 = "val1"
        nested {
          attr2 = "val2"
        }
      }
    HCL

    output = shell_output("#{bin}/hclgrep -x 'resource \"foo\" \"bar\" {@*_}' #{testpath}/test.hcl")
    assert_match 'resource "foo" "bar" {', output
  end
end

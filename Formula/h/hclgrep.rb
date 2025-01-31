class Hclgrep < Formula
  desc "Syntax based grep for HCL(v2)"
  homepage "https://github.com/magodo/hclgrep"
  url "https://github.com/magodo/hclgrep/archive/00059cbc78022cab225e172cc695c5edf1e4b8ef.tar.gz"
  version "0.0.0"
  sha256 "d6010eeb679e660ecd8612d5081ccc10a199482d266e01c530cbdd94bf6d666e"
  license "BSD-3-Clause"
  head "https://github.com/magodo/hclgrep.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a79a820731932a61a1ad259c70714ac3da8a69831f6305f42f64c0cbda523690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf3b71b3bf7334c20d3d6a3a5610c023fa3301b891a87af4268051bf72a8eda2"
    sha256 cellar: :any_skip_relocation, ventura:       "9f1e17eca3761bc11f4aee7e1bbb1e16d6f8e016c424b6e8d83baa5d5430a5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324ee0ac1044ac7425541ea087b2b4efcc293d4a3f2ae4c107f066ae5b3cf46c"
  end

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

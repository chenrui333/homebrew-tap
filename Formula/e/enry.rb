class Enry < Formula
  desc "Faster file programming language detector"
  homepage "https://github.com/go-enry/enry"
  url "https://github.com/go-enry/enry/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "39058e160b27828eceadaf374bfb380434acdcf8857da4a0b3e3600c1d136cac"
  license "Apache-2.0"
  head "https://github.com/go-enry/enry.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4b4122bad5b7dd5f52aec3fd1496eea4f523ae6142997d1c2f4dc8ab487d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915adaf0cf0a1d9744ad238639e76098337af96e9fa8bc61b1b47a6067367174"
    sha256 cellar: :any_skip_relocation, ventura:       "68a1c5aa23e62f72dc92b1b95058eb603d34682b2bd4e32a4fd4cf3b93e8182c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88bc7612e1d31883553e890ae7c2e880136c93f7429da16d8493e61df7b6e8cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enry --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, world!")
      }
    GO

    output = shell_output("#{bin}/enry test.go")
    assert_equal <<~EOS, output
      test.go: 7 lines (5 sloc)
        type:      Text
        mime_type: text/x-go
        language:  Go
        vendored:  false
    EOS
  end
end

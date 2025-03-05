class Enry < Formula
  desc "Faster file programming language detector"
  homepage "https://github.com/go-enry/enry"
  url "https://github.com/go-enry/enry/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "39058e160b27828eceadaf374bfb380434acdcf8857da4a0b3e3600c1d136cac"
  license "Apache-2.0"
  head "https://github.com/go-enry/enry.git", branch: "master"

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

class Enry < Formula
  desc "Faster file programming language detector"
  homepage "https://github.com/go-enry/enry"
  url "https://github.com/go-enry/enry/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "39058e160b27828eceadaf374bfb380434acdcf8857da4a0b3e3600c1d136cac"
  license "Apache-2.0"
  revision 1
  head "https://github.com/go-enry/enry.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8308f978a1b231d2966eada20f716d87a5362966e827870fbad35dee558d726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8308f978a1b231d2966eada20f716d87a5362966e827870fbad35dee558d726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8308f978a1b231d2966eada20f716d87a5362966e827870fbad35dee558d726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b63fb25b3f829f58b7e67d19526c733c8f2cb7b1b6508bea5b91d2f1650232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24e0c16a52b3479d9bb93a90b00f8b3d96e608d951b053435738c7f98b14104"
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

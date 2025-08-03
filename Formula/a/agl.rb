class Agl < Formula
  desc "Language that compiles to Go"
  homepage "https://alaingilbert.github.io/agl/"
  url "https://github.com/alaingilbert/agl/archive/79d325308eb03251a67542df1c170b08a569203c.tar.gz"
  version "0.0.1"
  sha256 "77fb75f5a03398cec2b13dcc99cc7605be3fdb59f545c6eeab4567f6a7a80c3d"
  license "MIT"
  head "https://github.com/alaingilbert/agl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171230527311d2d6d3cce50155976a56b5c8b6b959e8cffc9601151c8a3c1f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b82f4d04d60ea0f35b45a1e4a9d67990cee1b175ae52a48c19946c3f84de64e4"
    sha256 cellar: :any_skip_relocation, ventura:       "e41a684a3032421e4a29d6753062bd8618e32aade8c3b69c32bf695338ef9e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc1b814b49c997b561ca5ff5dfbd9cf96bc4f25fc434991a82287de04f15c770"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agl --version")

    (testpath/"hello.agl").write <<~AGL
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, AGL!")
      }
    AGL

    system bin/"agl", "build", "hello.agl"
    assert_path_exists testpath/"hello.go"
    assert_match "Hello, AGL!", shell_output("go run hello.go")
  end
end

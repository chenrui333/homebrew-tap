class Agl < Formula
  desc "Language that compiles to Go"
  homepage "https://alaingilbert.github.io/agl/"
  url "https://github.com/alaingilbert/agl/archive/79d325308eb03251a67542df1c170b08a569203c.tar.gz"
  version "0.0.1"
  sha256 "77fb75f5a03398cec2b13dcc99cc7605be3fdb59f545c6eeab4567f6a7a80c3d"
  license "MIT"
  head "https://github.com/alaingilbert/agl.git", branch: "master"

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

class Mockgen < Formula
  desc "Mock code generator for Go interfaces"
  homepage "https://github.com/uber-go/mock"
  url "https://github.com/uber-go/mock/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e315da02f11069f4e9688054cf8dba86535318ea28ab7a2fe144c5e6a859e329"
  license "Apache-2.0"
  head "https://github.com/uber-go/mock.git", branch: "main"

  depends_on "go" => [:build, :test]

  def install
    cd "mockgen" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    ENV["GOPATH"] = testpath/"go"
    src = testpath/"go/src/greeter"
    src.mkpath

    (src/"greeter.go").write <<~GO
      package greeter

      type Greeter interface {
        Greet(name string) string
      }
    GO

    cd src do
      output = shell_output("#{bin}/mockgen -source greeter.go -package greeter")
      assert_match "MockGreeter", output
    end
  end
end

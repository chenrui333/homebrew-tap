class Mockgen < Formula
  desc "Mock code generator for Go interfaces"
  homepage "https://github.com/uber-go/mock"
  url "https://github.com/uber-go/mock/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e315da02f11069f4e9688054cf8dba86535318ea28ab7a2fe144c5e6a859e329"
  license "Apache-2.0"
  head "https://github.com/uber-go/mock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ad1a69790b85b2f1cfa2c9c431fe15119234897422d39a47c8382cd27bcb7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad1a69790b85b2f1cfa2c9c431fe15119234897422d39a47c8382cd27bcb7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad1a69790b85b2f1cfa2c9c431fe15119234897422d39a47c8382cd27bcb7c3"
    sha256 cellar: :any_skip_relocation, sequoia:       "0423d869544eb90c04c16659a81088eb3c5b6c00f04de4f5caedc78dabba964c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab9ed1c02f43a6d3f2625d6b972dba5ba701a65e79d2f250a9a6cb346408e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81707a759e11898803d4a2b64428160a096ec33914358f7602bcd805d27996d7"
  end

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

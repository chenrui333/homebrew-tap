class Mockgen < Formula
  desc "Mock code generator for Go interfaces"
  homepage "https://github.com/uber-go/mock"
  url "https://github.com/uber-go/mock/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e315da02f11069f4e9688054cf8dba86535318ea28ab7a2fe144c5e6a859e329"
  license "Apache-2.0"
  head "https://github.com/uber-go/mock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f689904be1bb63010e007439b95a54d2bda28b17d1408c6a18e30795427b3996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f689904be1bb63010e007439b95a54d2bda28b17d1408c6a18e30795427b3996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac8605d2c295b60cc547a0a02797e6bc97dfa8c658ecb8e5c3ca3ed9c4cbd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "804c77767ff2ff00b3315e0ae71601b8a3b98cf91f26de6b8e1579a60f7bfbcd"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

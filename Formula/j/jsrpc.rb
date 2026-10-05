class Jsrpc < Formula
  desc "远程调用(rpc)浏览器方法，免去抠代码补环境"
  homepage "https://github.com/jxhczhl/JsRpc"
  url "https://github.com/jxhczhl/JsRpc/archive/refs/tags/v1.099.tar.gz"
  sha256 "da0d0b38d3cfee8af5e2378e007fdfc2fff8db22443ac6b58b24e9e4ce7edad6"
  license "GPL-3.0-or-later"
  head "https://github.com/jxhczhl/JsRpc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51f84fdbb5d91d88f6dc8b272d28ac609c744542db92a908872a188f519f732f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f84fdbb5d91d88f6dc8b272d28ac609c744542db92a908872a188f519f732f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e49b866969a13e2db7d523a558994430563b396eb3e814befbdb77410e72aab6"
    sha256 cellar: :any,                 x86_64_linux:  "4bfacdf8cc9e7b16ab22e6de3ebe1e3cdce8492cd1d676098c1e4cca15020478"
  end

  depends_on "go" => :build

  # The only interface is an HTTP server; the test queries it over a loopback socket.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      BasicListen: "127.0.0.1:#{port}"
    YAML

    pid = spawn bin/"jsrpc"
    sleep 1
    assert_match "{\"data\":{},\"status\":200}", shell_output("curl -s http://127.0.0.1:#{port}/list")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

class Jsrpc < Formula
  desc "远程调用(rpc)浏览器方法，免去抠代码补环境"
  homepage "https://github.com/jxhczhl/JsRpc"
  url "https://github.com/jxhczhl/JsRpc/archive/refs/tags/v1.095.tar.gz"
  sha256 "4bc104d1c3ccf46034db063d82f5ba1d0fa6f131501644594c17cfdcbce53044"
  license "GPL-3.0-or-later"
  head "https://github.com/jxhczhl/JsRpc.git", branch: "main"

  depends_on "go" => :build

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

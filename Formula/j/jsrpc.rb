class Jsrpc < Formula
  desc "远程调用(rpc)浏览器方法，免去抠代码补环境"
  homepage "https://github.com/jxhczhl/JsRpc"
  url "https://github.com/jxhczhl/JsRpc/archive/refs/tags/v1.098.tar.gz"
  sha256 "661d428fff00516b09c1d507bb307b9630e19f34b9740eb62daa1207b4ef4efd"
  license "GPL-3.0-or-later"
  head "https://github.com/jxhczhl/JsRpc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be843c19939002c64db60cb62560a522c3dba092a40e238f5a78e67089a2736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21fbeeae36e641d0595d74c5af83a51b7fcaa464379c12b67c184bf829e9fd42"
    sha256 cellar: :any_skip_relocation, ventura:       "1b6ba09913f7eb97ffa84ee9da97f5e7056eaa7e62a3dced384eace3e98b6aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480c3f3638c1d7aedf035418e59d259c12bd2f4ae9b95a8d2497313a4461f569"
  end

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

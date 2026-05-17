class Jsrpc < Formula
  desc "远程调用(rpc)浏览器方法，免去抠代码补环境"
  homepage "https://github.com/jxhczhl/JsRpc"
  url "https://github.com/jxhczhl/JsRpc/archive/refs/tags/v1.099.tar.gz"
  sha256 "da0d0b38d3cfee8af5e2378e007fdfc2fff8db22443ac6b58b24e9e4ce7edad6"
  license "GPL-3.0-or-later"
  head "https://github.com/jxhczhl/JsRpc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d86be4e23046aac673289b2831095d2416619bd75924983328b18bcc0994882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d86be4e23046aac673289b2831095d2416619bd75924983328b18bcc0994882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d86be4e23046aac673289b2831095d2416619bd75924983328b18bcc0994882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8658300093fd44222f91d3e3edaac14b056a93da90fd1048e1beeb0d404d92da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d3be5d90f05c1f60965f49e0deaacef33651d002266e4a66cb39c978b04c2f"
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

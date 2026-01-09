class Jsrpc < Formula
  desc "远程调用(rpc)浏览器方法，免去抠代码补环境"
  homepage "https://github.com/jxhczhl/JsRpc"
  url "https://github.com/jxhczhl/JsRpc/archive/refs/tags/v1.098.tar.gz"
  sha256 "661d428fff00516b09c1d507bb307b9630e19f34b9740eb62daa1207b4ef4efd"
  license "GPL-3.0-or-later"
  head "https://github.com/jxhczhl/JsRpc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73c416d374db3a42cfde4c4a523ef6bacbb305985352fc882c87bbd10db16e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c416d374db3a42cfde4c4a523ef6bacbb305985352fc882c87bbd10db16e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73c416d374db3a42cfde4c4a523ef6bacbb305985352fc882c87bbd10db16e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6164dc6a5dfc52a5b3f508282c618d026504e1f158539f4a6970baa3d4b33b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c391ea92ff12902963577914480769e17d78b072e682dd6dd601a552f4a26cf"
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

class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d9c367a80b682d5fbdbafb9abfccc9df7e56c24c03f7e1f9187500d4dbe2d380"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877555f7ca1870925aa20f6288c57aac133fe21f3721700b6aefe1ff54d71c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877555f7ca1870925aa20f6288c57aac133fe21f3721700b6aefe1ff54d71c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "877555f7ca1870925aa20f6288c57aac133fe21f3721700b6aefe1ff54d71c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b7c91bfcde1c042a68399b9b4912196e4c173f46901828e99d112cd0ba45a18"
    sha256 cellar: :any,                 x86_64_linux:  "30409a2d0494d4464fe296443bd0857f425bc2dd3dd80b9dff307df31630302f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Cod-e-Codes/marchat/shared.ClientVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.ServerVersion=#{version}
      -X github.com/Cod-e-Codes/marchat/shared.BuildTime=#{time.iso8601}
      -X github.com/Cod-e-Codes/marchat/shared.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  test do
    ENV["MARCHAT_ADMIN_KEY"] = "your-generated-key"
    ENV["MARCHAT_USERS"] = "admin1,admin2"

    output_log = testpath/"output.log"
    pid = spawn bin/"marchat", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match version.to_s, output_log.read
    assert_match(/TLS:.*Disabled/m, output_log.read)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

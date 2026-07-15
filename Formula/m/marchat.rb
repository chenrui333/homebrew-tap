class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "5e6396c21a179d23f86c7ba4f61f255fc15562606a3b3dc3f2cd94796898d287"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551cab92e3486e7d8aa8a0f5b951c58a23030b414fcbacf38d3081b91ff8a273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551cab92e3486e7d8aa8a0f5b951c58a23030b414fcbacf38d3081b91ff8a273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551cab92e3486e7d8aa8a0f5b951c58a23030b414fcbacf38d3081b91ff8a273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b49f632d2d04b059f0dc0009015d9737d0cc3c0891d4d65db1ed01f0ac1ab5f0"
    sha256 cellar: :any,                 x86_64_linux:  "388bdaedc69ded418cc3b03bd0df9092fd7c1f7e072208554ae9a7df37e3ae54"
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

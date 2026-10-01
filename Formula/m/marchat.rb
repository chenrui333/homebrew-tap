class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "0eed729ce60d1ed31f43a0f237bfd908c4ce4396e8ab46b2a355686893edd6b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55623aaf494a76cad5a8054e188b79454a41ced1f5b828bae3b0ae74b6148594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55623aaf494a76cad5a8054e188b79454a41ced1f5b828bae3b0ae74b6148594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16502ee1d24b0bcb260730bfa821c97c8a8f8bb746910a383db66997ce5a0d3e"
    sha256 cellar: :any,                 x86_64_linux:  "9899122adc0f17703ce8e05a66a1a721ca8c9ea350259f6713e2a83c1ae13439"
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

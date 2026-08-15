class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "efe8e2b9a302ef9dbaf636ac130ff0039e2026995c51ed6a022287a4c52a63c2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73edd5a17881e56f5a1673cc8b626cec116e04bbb7aa386048dce5d478d01365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73edd5a17881e56f5a1673cc8b626cec116e04bbb7aa386048dce5d478d01365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73edd5a17881e56f5a1673cc8b626cec116e04bbb7aa386048dce5d478d01365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640fc32d2407dc70444f18aca320ad012c117f3a6c93f003686df79128128045"
    sha256 cellar: :any,                 x86_64_linux:  "9fa87f627a31ffaf816b726c5a00774936a30171810831249895bb16cb3bd8d0"
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

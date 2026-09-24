class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "291a4fbde08fc1255d2e63d9e8ef4ab60fe5230040736973745231a8a7822c41"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d703277b737d55124063880d9e593ede4fcc966c1feb84be5354c7fb7efe3ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d703277b737d55124063880d9e593ede4fcc966c1feb84be5354c7fb7efe3ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d992523e049c1a378f4f6cd99a44f3d00465470184336d8f1d1dff706581dd7c"
    sha256 cellar: :any,                 x86_64_linux:  "b953a13c461e212f03a486404ca081869cb8fca768035645a6236b68bf79d618"
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

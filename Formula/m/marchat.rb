class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5384c419313646a7b2721b1556fd0bb8bf83b5c509b8d902cf02ba9d85210c53"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0817ec44c38c6b5964d409572a6832bdcacabfe6de26349f86a1e605933f579f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0817ec44c38c6b5964d409572a6832bdcacabfe6de26349f86a1e605933f579f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0817ec44c38c6b5964d409572a6832bdcacabfe6de26349f86a1e605933f579f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50687158d17001b553d8753440fddd0e6bf0a5b65d8143a5cfae1faf99c768af"
    sha256 cellar: :any,                 x86_64_linux:  "5ccfd8b923c92350d7ff69e3a411f1536960578a7ca4e618eac884c8f754e24a"
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
    assert_match "TLS: Disabled", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

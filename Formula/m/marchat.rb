class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "5e6396c21a179d23f86c7ba4f61f255fc15562606a3b3dc3f2cd94796898d287"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31a97606928c2a4d3ff62710cbbd9937771cab6b46c413cf970e1f5078599070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31a97606928c2a4d3ff62710cbbd9937771cab6b46c413cf970e1f5078599070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31a97606928c2a4d3ff62710cbbd9937771cab6b46c413cf970e1f5078599070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31098d7b743c4bb44fd26d53aaf1d6a03d904fa9ba462c93bbf1d74e8a152d91"
    sha256 cellar: :any,                 x86_64_linux:  "fc6cb73ba6cdb976bc07f3ff068b4498982a9a3ac49fcec5ef487a88a1797063"
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

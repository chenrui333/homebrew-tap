class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9bc2ddd67a68c0baeefcb54c9ba58d1b98b2886608bb9fbe7bad7b39a5e43a22"
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

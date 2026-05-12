class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2a0bbc6129e5fa28a8d35dccaf8f1c14b98e2f9a0f775f62cfea68577153203f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2b56cff49db36a599b6b304a4309f4faec8f3fe45e5c3c3bf85a0fdc16159ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b56cff49db36a599b6b304a4309f4faec8f3fe45e5c3c3bf85a0fdc16159ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b56cff49db36a599b6b304a4309f4faec8f3fe45e5c3c3bf85a0fdc16159ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c74211306e64bdc8131f54426758945c99461478e7cb3a0ab3de3f24ffd0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880fd953f5d7ac5ccc04dea559f9e20848ca761cd6c2dc54a685a3913954e27d"
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

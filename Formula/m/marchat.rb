class Marchat < Formula
  desc "Terminal chat with WebSockets, E2E encryption, plugins, and file sharing"
  homepage "https://github.com/Cod-e-Codes/marchat"
  url "https://github.com/Cod-e-Codes/marchat/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fcd8439949a4671c6f452f1e90fc3b02e0dc61ebd9794a46fe6531f0166f8018"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b91041fd360463bf7769a39fe80e2d48b5ec80a8a5610976c69f2eb538d937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b91041fd360463bf7769a39fe80e2d48b5ec80a8a5610976c69f2eb538d937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b91041fd360463bf7769a39fe80e2d48b5ec80a8a5610976c69f2eb538d937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f59bed8001016e879b11a6ba66e5be3ad224a81c2379587b96449d5f05cbc85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ca06e57aa89cd19176b0ded17fef368cc51aebf7cb58d9b42cfd245d4ca011"
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

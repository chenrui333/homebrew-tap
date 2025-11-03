class Inbucket < Formula
  desc "Disposable webmail server with SMTP, POP3, and REST interfaces"
  homepage "https://inbucket.org/"
  url "https://github.com/inbucket/inbucket/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e5342594f25c06a27b6d892d6b96f0c4b17bd1a1841fd19f79a57bf58984495f"
  license "MIT"
  head "https://github.com/inbucket/inbucket.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/inbucket"
    system "go", "build", *std_go_args(ldflags:, output: bin/"inbucket-client"), "./cmd/client"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inbucket --version")
    output = shell_output("#{bin}/inbucket-client list test 2>&1", 1)
    assert_match "Couldn't build client: parse \"http://%slocalhost:9000\"", output
  end
end

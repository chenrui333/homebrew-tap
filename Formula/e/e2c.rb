class E2c < Formula
  desc "TUI application for managing AWS EC2 instances"
  homepage "https://github.com/nlamirault/e2c"
  url "https://github.com/nlamirault/e2c/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "88eae361fc6d8c843a82d889f79f89798b65b6fdc72c2e3ac2b4f6a0cf2af45b"
  license "Apache-2.0"
  head "https://github.com/nlamirault/e2c.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/nlamirault/e2c/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/e2c"

    generate_completions_from_executable(bin/"e2c", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2c --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"e2c", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No config file found, using defaults", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

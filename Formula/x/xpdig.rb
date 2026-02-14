class Xpdig < Formula
  desc "Dig into Crossplane traces via TUI"
  homepage "https://github.com/brunoluiz/xpdig"
  url "https://github.com/brunoluiz/xpdig/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "22ae565b85835940fd2b66dca255ddb54febef31b07fe064321811701fe3f23a"
  license "Apache-2.0"
  head "https://github.com/brunoluiz/xpdig.git", branch: "main"

  depends_on "go" => :build
  depends_on "crossplane"

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/xpdig"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/xpdig version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"xpdig", "trace", "test/invalid", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "failed to get kubeconfig: invalid configuration", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

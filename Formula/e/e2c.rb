class E2c < Formula
  desc "TUI application for managing AWS EC2 instances"
  homepage "https://github.com/nlamirault/e2c"
  url "https://github.com/nlamirault/e2c/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "305211335f7c1cdebfcca8ed0fe51028c28e015f5ad17453cde33d1da5f76381"
  license "Apache-2.0"
  head "https://github.com/nlamirault/e2c.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c89cbafb51dda52fb0189c4b775746d6ab74b166566abbdb488c511a9d81372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c89cbafb51dda52fb0189c4b775746d6ab74b166566abbdb488c511a9d81372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c89cbafb51dda52fb0189c4b775746d6ab74b166566abbdb488c511a9d81372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5456832f56e3f53f7f8f67d6fcb48c9fe4b24729c20f9504f51376145ce33139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8825cd2ff25c4707526ce9ce657b0b9d60cf687e5c1a963326b75f24277d3208"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/nlamirault/e2c/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/e2c"

    generate_completions_from_executable(bin/"e2c", shell_parameter_format: :cobra)
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

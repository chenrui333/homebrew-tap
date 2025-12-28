class E2c < Formula
  desc "TUI application for managing AWS EC2 instances"
  homepage "https://github.com/nlamirault/e2c"
  url "https://github.com/nlamirault/e2c/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "88eae361fc6d8c843a82d889f79f89798b65b6fdc72c2e3ac2b4f6a0cf2af45b"
  license "Apache-2.0"
  head "https://github.com/nlamirault/e2c.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ba1e1cc888de05e26c56e3e41c2b70baa3baae3aaa7531435c3a8e6be6846c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ba1e1cc888de05e26c56e3e41c2b70baa3baae3aaa7531435c3a8e6be6846c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba1e1cc888de05e26c56e3e41c2b70baa3baae3aaa7531435c3a8e6be6846c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded030746b73bab7158bbbc61e7d207a3076d18282c8a0a5f1a905239b0debe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845c55645573a0333e6c23c227d66dd3be056d8ab282a2fb0f7149bce903ca8e"
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

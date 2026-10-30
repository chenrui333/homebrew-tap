class TdCli < Formula
  desc "Task management for AI-assisted development"
  homepage "https://github.com/marcus/td"
  url "https://github.com/marcus/td/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "fc33c534963f9de9c2730cb4731ac638f444e7a7875c120475545c5922becbb3"
  license "MIT"
  head "https://github.com/marcus/td.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0601cbdca2c553bed3471503e11f5296b1c42da8a1c77d8779f9eedc2d7a633d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0601cbdca2c553bed3471503e11f5296b1c42da8a1c77d8779f9eedc2d7a633d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27aa856ba239f028f9cda910456abf1361e4dc929c3f7ab47abb7be0f32c5e67"
    sha256 cellar: :any,                 x86_64_linux:  "7249a23fe22722893a87f00022d7db718332c533c1f14cd8b88c158d1bb551b4"
  end

  depends_on "go" => :build

  conflicts_with "td", because: "both install `td` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/"td")
    generate_completions_from_executable(bin/"td", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td version")

    system bin/"td", "init"
    system bin/"td", "create", "Verify source-built task tracking", "--type", "task"
    tasks = JSON.parse(shell_output("#{bin}/td list --json"))
    assert_equal "Verify source-built task tracking", tasks.fetch(0).fetch("title")
    assert_equal "open", tasks.fetch(0).fetch("status")
  end
end

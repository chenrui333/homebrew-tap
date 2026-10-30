class TdCli < Formula
  desc "Task management for AI-assisted development"
  homepage "https://github.com/marcus/td"
  url "https://github.com/marcus/td/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "fc33c534963f9de9c2730cb4731ac638f444e7a7875c120475545c5922becbb3"
  license "MIT"
  head "https://github.com/marcus/td.git", branch: "main"

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

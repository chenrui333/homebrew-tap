class BashScriptTools < Formula
  desc "Web-based bash script formatter and linter with AI-powered autofix"
  homepage "https://github.com/overflowy/bash-script-tools"
  url "https://github.com/overflowy/bash-script-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "274dfcc090cae3c2595e2300705076e3dbd56102581ced0cd0b47eed217cf647"
  license "MIT"
  head "https://github.com/overflowy/bash-script-tools.git", branch: "main"

  depends_on "go" => :build
  depends_on "shellcheck"
  depends_on "shfmt"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    ENV["GROQ_MODEL_ID"] = "openai/gpt-oss-120b"

    pid = spawn bin/"bash-script-tools"
    sleep 1
    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Format and lint your Bash scripts", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

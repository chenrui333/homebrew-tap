class BashScriptTools < Formula
  desc "Web-based bash script formatter and linter with AI-powered autofix"
  homepage "https://github.com/overflowy/bash-script-tools"
  url "https://github.com/overflowy/bash-script-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "274dfcc090cae3c2595e2300705076e3dbd56102581ced0cd0b47eed217cf647"
  license "MIT"
  head "https://github.com/overflowy/bash-script-tools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23fcd5ea0964dca516b7a3e2d6633cd64cab441a702413bce371406a85410ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23fcd5ea0964dca516b7a3e2d6633cd64cab441a702413bce371406a85410ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23fcd5ea0964dca516b7a3e2d6633cd64cab441a702413bce371406a85410ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e87a0c29fda2925b07e9ae35c7876743c95169e4c6aa3cf07ff130eb430f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01822d8d287a058242cc5d3a718ffb61ebd78375246a5879eff233dc1199005"
  end

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

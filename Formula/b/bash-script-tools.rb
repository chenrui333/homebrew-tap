class BashScriptTools < Formula
  desc "Web-based bash script formatter and linter with AI-powered autofix"
  homepage "https://github.com/overflowy/bash-script-tools"
  url "https://github.com/overflowy/bash-script-tools/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c4a1554057dcd1e3a15edbf11d6c5ba232804082378d77cc620e05572ea7ffde"
  license "MIT"
  head "https://github.com/overflowy/bash-script-tools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d3e54eaa75922b53e864cd320b1dc755cb16b343bbef00ec6dcfa371af0f67f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3e54eaa75922b53e864cd320b1dc755cb16b343bbef00ec6dcfa371af0f67f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d3e54eaa75922b53e864cd320b1dc755cb16b343bbef00ec6dcfa371af0f67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6117e4a61125189e854f66003dcf2ddbf4a49587f7644c9f46eaac24629933e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e72fd1ef5fa4658191039ae1498b05eea9b8f2539d8b0c61fb21f52f742716"
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

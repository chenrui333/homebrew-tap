class BashScriptTools < Formula
  desc "Web-based bash script formatter and linter with AI-powered autofix"
  homepage "https://github.com/overflowy/bash-script-tools"
  url "https://github.com/overflowy/bash-script-tools/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a98b6b136298c0035385d0a4d3e185995a844ad8b1c7ebbbd42ead33f326a3c6"
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

    config_dir = testpath/"config"
    (config_dir/"bash-script-tools").mkpath
    (config_dir/"bash-script-tools/config.toml").write "port = #{port}\n"
    ENV["XDG_CONFIG_HOME"] = config_dir

    pid = spawn bin/"bash-script-tools"
    output = shell_output("curl --retry 10 --retry-connrefused --retry-delay 1 --max-time 15 -s " \
                          "http://localhost:#{port}/")
    assert_match "Format and lint your Bash scripts", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

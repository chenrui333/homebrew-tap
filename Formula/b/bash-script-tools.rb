class BashScriptTools < Formula
  desc "Web-based bash script formatter and linter with AI-powered autofix"
  homepage "https://github.com/overflowy/bash-script-tools"
  url "https://github.com/overflowy/bash-script-tools/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a98b6b136298c0035385d0a4d3e185995a844ad8b1c7ebbbd42ead33f326a3c6"
  license "MIT"
  head "https://github.com/overflowy/bash-script-tools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70f68283ede9c7eaf816af21ce1a6f650388ba22ecfee18a4ab165acdf898ef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f68283ede9c7eaf816af21ce1a6f650388ba22ecfee18a4ab165acdf898ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70f68283ede9c7eaf816af21ce1a6f650388ba22ecfee18a4ab165acdf898ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e783b8631ec9d74ff7dd82ea4e56bf5583dd48c405e79190f645bc23911d04fc"
    sha256 cellar: :any,                 x86_64_linux:  "8960ebcb228dda4b59061229a758304142eeeb6f063e8e807ac4d64b3f2b1481"
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

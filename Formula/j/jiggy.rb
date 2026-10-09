class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "57a380ff224e9f4eeea2a0031d6b30c9cacbbf3ce7b56e99225d16d09e4d6fad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f99ed59cb7b4ad206ca3ce01058614e5c25b3a9250b844de170791821420c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dddad3c96f1982c66a4ea68d2ded579a6b1c544cc2c92f662a8ba565dd08ce1e"
    sha256 cellar: :any,                 arm64_linux:   "fa3fb934b337fe31e19036f6216cc7f3034cb90ba08477f46fc4eeda185f5b8b"
    sha256 cellar: :any,                 x86_64_linux:  "05b401379ef9e522aee6d07266a5d128abc8036ec13803871acd9a3450cb05e9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version 2>&1", 1)

    # Error: DISPLAY environment variable is empty.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jiggy", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Just chillin' for 60s", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

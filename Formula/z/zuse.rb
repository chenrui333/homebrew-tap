class Zuse < Formula
  desc "Sleek, minimal IRC client for your terminal"
  homepage "https://github.com/babycommando/zuse"
  url "https://github.com/babycommando/zuse/archive/refs/tags/v1.0.tar.gz"
  sha256 "6ae04f645216981462f913049db1916d2b7761bf14e5c5259fc77d42582ddbda"
  license "Apache-2.0"
  head "https://github.com/babycommando/zuse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652942d978de4584b380585c9c19f61672ccd5983a478b6590aac324805e2103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652942d978de4584b380585c9c19f61672ccd5983a478b6590aac324805e2103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564b72b47b3684eaed9e3858463acd73b6e3c4684abe1aa359af7cded4510370"
    sha256 cellar: :any,                 x86_64_linux:  "f2bdb1000d0b7c9e81e1d715da1a793767924475edb431b3c971d6449690e21c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"zuse", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "loading…", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

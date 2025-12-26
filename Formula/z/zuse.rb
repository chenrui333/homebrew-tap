class Zuse < Formula
  desc "Sleek, minimal IRC client for your terminal"
  homepage "https://github.com/babycommando/zuse"
  url "https://github.com/babycommando/zuse/archive/refs/tags/v1.0.tar.gz"
  sha256 "6ae04f645216981462f913049db1916d2b7761bf14e5c5259fc77d42582ddbda"
  license "Apache-2.0"
  head "https://github.com/babycommando/zuse.git", branch: "main"

  depends_on "go" => :build

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

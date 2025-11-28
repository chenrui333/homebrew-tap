class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "311a7a3fb39cfbf478bd0a9ac2c6b5cc5fc509383edad223b119ec89f7ef66b5"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  depends_on "go" => :build

  # INSTALL_RECEIPT.json patch, upstream pr ref, https://github.com/hzqtc/taproom/pull/19
  patch do
    url "https://github.com/hzqtc/taproom/commit/a897689ac05447305eabdd0aa340293aec6a83dc.patch?full_index=1"
    sha256 "299c75d53e52ed5ed39f6cc14817a68c87560b744fdd7107107ffec2d3ed3473"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"taproom", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[1/6] Loading all Formulae...\r\n[2/6] Loading all Casks...", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

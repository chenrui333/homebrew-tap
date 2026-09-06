class Diskbloom < Formula
  desc "Visualize disk usage as a terminal treemap"
  homepage "https://github.com/Zingzy/diskbloom"
  url "https://github.com/Zingzy/diskbloom/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b0fa7c67c17251423b7e89fecf4c4d1f3722537a0049ba2771d90e24d0c8ebad"
  license "Apache-2.0"
  head "https://github.com/Zingzy/diskbloom.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diskbloom --version")
    # TODO: Replace the terminal requirement check when upstream exposes a headless scan mode.
    # Bubble Tea opens /dev/tty when stdin is redirected; detach the child from its terminal.
    (testpath/"no-tty.rb").write <<~RUBY
      pid = fork do
        Process.setsid
        exec ARGV.fetch(0), ARGV.fetch(1)
      end
      Process.wait(pid)
      exit $?.exitstatus
    RUBY
    output = shell_output("#{RbConfig.ruby} no-tty.rb #{bin}/diskbloom #{testpath} 2>&1", 1)
    assert_match "error opening TTY", output
  end
end

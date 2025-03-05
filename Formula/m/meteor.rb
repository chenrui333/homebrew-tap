# framework: bubbles
class Meteor < Formula
  desc "Highly configurable CLI tool for writing conventional commits"
  homepage "https://github.com/stefanlogue/meteor"
  url "https://github.com/stefanlogue/meteor/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "3c6f0bafcf27d26a3ef369084630488a4ca05324cb11e61b2e020d827bec51d1"
  license "MIT"
  head "https://github.com/stefanlogue/meteor.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "test@brew.sh"
      system "git", "commit", "--allow-empty", "-m", "test"

      test_config = testpath/".meteor.json"
      test_config.write <<~JSON
        {
          "showIntro": false
        }
      JSON

      logfile = testpath/"meteor.log"
      pid = spawn bin/"meteor", out: logfile.to_s, err: logfile.to_s
      sleep 1
      assert_match "Select the type of change you're committing", logfile.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

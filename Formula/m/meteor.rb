# framework: bubbles
class Meteor < Formula
  desc "Highly configurable CLI tool for writing conventional commits"
  homepage "https://github.com/stefanlogue/meteor"
  url "https://github.com/stefanlogue/meteor/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "fa87a800d45194cf46de313eed8ca7bfaa1d4bbf49f3c63ac0753f3ee193af18"
  license "MIT"
  head "https://github.com/stefanlogue/meteor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da46e859090c79f3cbe7d2705185c72abc95327c856757cc55a4d76e31c71c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee7fee4de98556c234f97aecf32bbf347f3dc426c23d9726c3a11fc0839f2c84"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ee7e5a203326102f17eddf5cafbc18b7b649c2eddd7228c422c00aa2ce66f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d217684a21e4a0518904220536ea8b92671af2a2c9e078fee0812f4afda0bb"
  end

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
      Process.kill("TERM", pid)
      assert_match "Select the type of change that you're committing", logfile.read
    end
  end
end

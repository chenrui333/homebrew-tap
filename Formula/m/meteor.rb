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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b7c051c826ad6287d605a07e6b337ccea2f32e7a7dff322038df6d4a66ae0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7b929d98fc9d047ba2146dbebc66f48595febcdda838b7a0aba5a62b154cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "de7a2b56f37e597210feac42873d4efebf3ac4009ced3c10e9b979e4aff05bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd9da36343b69c9ee72aa425c160e34f7315ad8c957a948148e9630ff015d61"
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

# framework: bubbles
class Meteor < Formula
  desc "Highly configurable CLI tool for writing conventional commits"
  homepage "https://github.com/stefanlogue/meteor"
  url "https://github.com/stefanlogue/meteor/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "0d935bcf5458237657917ef67f9cf263e3f9a5b2b2477f0ddd9ad4592da0d815"
  license "MIT"
  head "https://github.com/stefanlogue/meteor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965766862731902288b2e41746fc88d8cc76a0a1c91b8896bcd6764e9a555802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a95c35504345a0d87ca90cfb68d2f7676cca7e673291692c1d154635b1c1a1"
    sha256 cellar: :any_skip_relocation, ventura:       "52dfc4d80ecd76c81bed593c397a6cbc71b36a8423c62890f00b694d448f65f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6e76beef089f86ea5c39198d609742c0f51221fc6cf540992c25d56496c19d"
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
      assert_match "Select the type of change you're committing", logfile.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

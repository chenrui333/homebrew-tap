# framework: bubbles
class Meteor < Formula
  desc "Highly configurable CLI tool for writing conventional commits"
  homepage "https://github.com/stefanlogue/meteor"
  url "https://github.com/stefanlogue/meteor/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "8c6b5e56ebb31a1ffa94adfa226c970415bae61352699d8849e34773f7e42f91"
  license "MIT"
  head "https://github.com/stefanlogue/meteor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe313c17ce5c73195ac74df7ee975da19038a155818e47a4e9ca571ee33bc112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe313c17ce5c73195ac74df7ee975da19038a155818e47a4e9ca571ee33bc112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe313c17ce5c73195ac74df7ee975da19038a155818e47a4e9ca571ee33bc112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1ae24ad8b8dcb1765f669c75f3125588229065aad179ceeb562b7cece244de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85ff946a561abcb30ff751054f5d271edf37880b9d0af164d50e7eede3c3048"
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

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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe88d84c10af2bb8ff381ef9a5cd502ed27fbf44fd0f895ea966d3ddcc26a73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe88d84c10af2bb8ff381ef9a5cd502ed27fbf44fd0f895ea966d3ddcc26a73b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cced4504d3d734d3c4ae629c9c5cf73cdcf038a72f13b4d4560931185f70347"
    sha256 cellar: :any,                 x86_64_linux:  "8a75953d3bdfaf1bdc849d4802858369b070fd078add82d254239ff593dfb34b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

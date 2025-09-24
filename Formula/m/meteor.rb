# framework: bubbles
class Meteor < Formula
  desc "Highly configurable CLI tool for writing conventional commits"
  homepage "https://github.com/stefanlogue/meteor"
  url "https://github.com/stefanlogue/meteor/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "b1a9630798a208f1a825656d2325db6576817ccfbc304f7bae8b31305bd713c2"
  license "MIT"
  head "https://github.com/stefanlogue/meteor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f27be7b203ff1f5a6be2914d0ed7b9bf6832de72e9e9e05df5a7d95cec9d5654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35290bcadef527efe24fa78c4a53c78b9a576f35c127f8da1811e8fa1b3838b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa0c5b49fe61590e56c99e185c5fc11850499752ea11375c1f8d6877500e8c0"
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

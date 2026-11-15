class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "401d5ad5efabfebdbce2ae3c9aa3466c017a30b3af598f616d94c7ec57e47b1b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35f895e5e59bcc5e2eaa479dc8e9d70533c538859ae86bbec497b86f14910336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8441bd0a96d7b0e52b386840cbfbd8f775891314bd5dac435c19143bdc0a98"
    sha256 cellar: :any,                 arm64_linux:   "31b8b7444ad5aa90628e2cb5a64d6e969c5404b92300e82398d75bb004d811ea"
    sha256 cellar: :any,                 x86_64_linux:  "6da9cf6d0d10bd2603e3f4743e3d88a661fa03773b664d76c7bea6b6b3c4b38d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version 2>&1", 1)

    # Error: DISPLAY environment variable is empty.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jiggy", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Just chillin' for 60s", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

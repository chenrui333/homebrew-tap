class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "8ae5c61611b5a025180b00b932d1ebff9dab5991d4be0644e396d4312db48769"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a94f07e921aceecf82cbf90044fc7b6952da7c439fe50128d0edd72c74e916c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e840d8563138cc8f6480fc5799d2bd85eb474ea50110fdb3f6c82dd14ee6cdd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848efe2403f8bd3984c7ab3007eb378fb4cbd44c5605cd5ce07686643afc4289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1032ad5f600f62cbc6a1e9d4f5a027f13dd6cfb8b56dbf7f8ff9a41e10957006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf431033f8ba1fb2432e1e1d67c9403d4ea359e61f5d76b807848a3f2f3ae21"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
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

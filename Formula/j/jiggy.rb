class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4aafddd91d10c8fa9ed6d385729cdde49fe717beeec5ce33da03a814b81fb07c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571dfc474d46e02b02a5e56dc23ea1935182e2b84b4e842fc1c14ddfa6ac3946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b6fbbf4e2f331041368dcecb40fbbbfa666fda502fce7d3b7cd69386661b92"
    sha256 cellar: :any_skip_relocation, ventura:       "56d3a4f2854bd74494f14c2571f1536e7ada1dd80d0313a4c8438c9690c032db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5647aee988544eba0e2437cfb017f656b630f8689f55dd3c1473144ca82402"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version")

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

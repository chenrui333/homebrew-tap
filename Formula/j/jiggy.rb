class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c857a6b108fc951ba67fe7d637c6a6bced83f01dbdb9710615009e764715ae24"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9a231c183a1490ee13b2b074b7df946978d3f2a0832dbee853cb1fae4b5b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f198ba9aa5c28317a932285e11a549bd63c8992073f3c36df3246e958be285c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b90063c030689ff4fcb7341f1b1abc6add58dec2465fb39d171d24a6bd5507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085125fe039ef8a0320ba8731405ba8e1a104679bf04f55ebdda9dce96cf24a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcbe237a70bbf79c465243f511cee41888d27bbb6c13a5b01a461bf5a69e2056"
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

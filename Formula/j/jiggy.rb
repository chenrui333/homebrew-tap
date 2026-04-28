class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "49f8d2e064f43e984de2363d3b067ac02646251894eff4711b507572aeb3add1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bc3f37ed3e8ed3a2b1b6314823bf8e2dbd8437e646c39ba40a06a5353c1da44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b704a0014f1c9e7f539570d8aac570bb393db10f761bb48687fa3788781903a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d3c1ad1f8dfd4a5ac6bfc2ece3d5c584ba88d31c75280f10316d763018aa8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566c6de0127a185dd75f78b029e75d92da90f7c7645576b3fd1b38aea9463d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4476e12df2298143bc12f6450bd323c711a721977f4401a7e4cc1c48dabcdb0f"
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

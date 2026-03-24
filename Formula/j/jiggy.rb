class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "f930a9ac80f065e145c66d7d0e5c78894c196397d2272fb73ac5153d8bfca9d1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da4b2dc72a12ec5cf310ce38f78e9361af0d41953efdb6d41528157cadcdee3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2188feaa4c514438135df2c3379db88fe61b07531fbf45896aa38ec2d7fed266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf1009b004804010422ba46ca12a25358095c36211f98ad3d13cae0ab12927c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80711608287263f15368bc14dc487f3b596b736ef7d26987662446a57a3b950b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70233eae88a02f021be26c3e1c1f36e896332f9fc3c8fc4b69ada5ec3a353f52"
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

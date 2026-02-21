class Clawea < Formula
  desc "Terminal-based weather forecast application"
  homepage "https://github.com/Cladamos/clawea"
  url "https://github.com/Cladamos/clawea/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "63f02bae943f7142d5257366c2ca101396f2561ad5d913f2bbcc43356ae79384"
  license :cannot_represent
  head "https://github.com/Cladamos/clawea.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d23b1df41ec244c84e1b88790b03eeeb964d2033c18c73fc0f5e10fc931d04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d23b1df41ec244c84e1b88790b03eeeb964d2033c18c73fc0f5e10fc931d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0d23b1df41ec244c84e1b88790b03eeeb964d2033c18c73fc0f5e10fc931d04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b18d684b45bdef076b51b0b86f1cc4a83ea36f652f019f13f17f187efd3983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f5c2cb5ddad7994cc020c1a2e4171a0cf5f42c00c3f143879528b8cebf3923"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_file = testpath/"clawea-test.log"
    pid = fork do
      Process.setsid
      $stdin.reopen(File::NULL)
      $stdout.reopen(output_file, "w")
      $stderr.reopen(output_file, "a")
      exec bin/"clawea"
    end
    Process.wait(pid)

    output = output_file.read
    assert_match "Error running program:", output
    assert_match "/dev/tty", output
  end
end

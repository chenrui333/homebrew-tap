class Clawea < Formula
  desc "Terminal-based weather forecast application"
  homepage "https://github.com/Cladamos/clawea"
  url "https://github.com/Cladamos/clawea/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "939e15ba6bc99c42ceb280e487596f58a4c12967bdb9c8c7d4910439a7a40df4"
  license :cannot_represent
  head "https://github.com/Cladamos/clawea.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65036dbe21fbd659339bc303f5ac6eff45de7951d49ac04c9979357509e0b7d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65036dbe21fbd659339bc303f5ac6eff45de7951d49ac04c9979357509e0b7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65036dbe21fbd659339bc303f5ac6eff45de7951d49ac04c9979357509e0b7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "655e5ada2fa9ba84fdf857178682638d6378ff4fc5943fe50c5f423f7071dcae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a5eba1001b64ff0909f9b4ebb07e1645649db58b187437ca8b4972e9fa67e2"
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

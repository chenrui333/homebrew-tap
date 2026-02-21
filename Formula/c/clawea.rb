class Clawea < Formula
  desc "Terminal-based weather forecast application"
  homepage "https://github.com/Cladamos/clawea"
  url "https://github.com/Cladamos/clawea/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "63f02bae943f7142d5257366c2ca101396f2561ad5d913f2bbcc43356ae79384"
  license :cannot_represent
  head "https://github.com/Cladamos/clawea.git", branch: "main"

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

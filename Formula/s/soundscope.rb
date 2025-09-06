class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "0a2eedcc78da188dbf5fd785587293c4b0dfc6831e40d19310503826e6f0e1e3"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"soundscope", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "mid Frequency", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

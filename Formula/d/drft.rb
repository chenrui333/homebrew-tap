class Drft < Formula
  desc "Diff re/viewer, file tree"
  homepage "https://codeberg.org/nightsail/drft"
  url "https://codeberg.org/nightsail/drft/archive/0.1.1.tar.gz"
  sha256 "c5be1a8e24929a03767f9bb5475371fd2a9293ae96f86f23b1e3f8098b6f8307"
  license "BSD-3-Clause"
  head "https://codeberg.org/nightsail/drft.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"diff.patch").write <<~EOS
      --- a/file.txt
      +++ b/file.txt
      @@ -1 +1 @@
      -Hello, world!
      +Hello, Homebrew!
    EOS

    output_log = testpath/"output.log"
    pid = spawn bin/"drft", "diff.patch", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "+Hello, Homebrew", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

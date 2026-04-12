class Drft < Formula
  desc "Diff re/viewer, file tree"
  homepage "https://codeberg.org/nightsail/drft"
  url "https://codeberg.org/nightsail/drft/archive/1.1.0.tar.gz"
  sha256 "f1f67e9890d1d9e22f232dc06e96df4fcb4f570566377c3d356711083d9658be"
  license "BSD-3-Clause"
  head "https://codeberg.org/nightsail/drft.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a02b60041b4a74f7cb4c8833fac48af3cfa84b878e3435240127dfd5f3b668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbd01ac1c8b79899caa3ce0f6a614650e3aa5ad68372e2c89213fb1ea7a9540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7fdf8bb6e2235968b9bdf3625cde4bde4a49dcb4c7199c4614a5cf8a18ab986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0227c33c5b696c549095a904a0f585f1236ddbe3f7294f29c8b4f6af3f96c40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd348d5ed505d0dc15662482b1cc9d4fd3b4a33f3092a4025ea03d91be13bcc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `code: 6, kind: Uncategorized, message: \"No such device or address\"`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
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
end

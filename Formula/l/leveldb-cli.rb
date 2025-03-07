class LeveldbCli < Formula
  desc "CLI for LevelDB"
  homepage "https://github.com/liderman/leveldb-cli"
  url "https://github.com/liderman/leveldb-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d1e4fb7fba36c15d0f4456bef2a8f138f6424a065fc5b5c2bb7a5396c3b4cfde"
  license "MIT"
  head "https://github.com/liderman/leveldb-cli.git", branch: "master"

  depends_on "go" => :build

  def install
    # patch version
    inreplace "main.go", "0.3.0", version.to_s if build.stable?
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"leveldb-cli", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "LevelDB CLI", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

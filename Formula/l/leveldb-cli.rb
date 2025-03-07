class LeveldbCli < Formula
  desc "CLI for LevelDB"
  homepage "https://github.com/liderman/leveldb-cli"
  url "https://github.com/liderman/leveldb-cli/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d1e4fb7fba36c15d0f4456bef2a8f138f6424a065fc5b5c2bb7a5396c3b4cfde"
  license "MIT"
  head "https://github.com/liderman/leveldb-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d24f38596d5bc2c1900aa986e920bad07bfc4c428effc445f9bfe9271c8d425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c441774c705c3778647b3e0baf1bc36fe606b89438c39e61674b6ce5b1b81a97"
    sha256 cellar: :any_skip_relocation, ventura:       "3a12dc0dca2dd2c4c037f10713aa1353a18731d183623ed74f583ed73c9bd4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e72ed30cc8ca68009eae11b8e650be1f8a9664d7cd9ae7a13a52a91cce6203bf"
  end

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

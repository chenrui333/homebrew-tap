class LeveldbCli < Formula
  desc "CLI for LevelDB"
  homepage "https://github.com/liderman/leveldb-cli"
  url "https://github.com/liderman/leveldb-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c6dcb3d960c1a8c0f8209c6a1cccb147b66aa23f100e14fcbddcb0784bacd90b"
  license "MIT"
  head "https://github.com/liderman/leveldb-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29067f9be02820fd7849b6f4ff863e46d0813fc9f5b54fa33d2b0964e0c942ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fedcfe1e50ba04c8f8d83a71e9ec6a3b0214018136d73d4696f3c604770a540"
    sha256 cellar: :any_skip_relocation, ventura:       "66dc4307ae5097d717f797b83796b1b0943db06764eee618fc078f27e5b23ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3e786c867f2305185246b9042aa00979467d0cba5fb3316792cde92de2011e"
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

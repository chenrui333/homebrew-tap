class LeveldbCli < Formula
  desc "CLI for LevelDB"
  homepage "https://github.com/liderman/leveldb-cli"
  url "https://github.com/liderman/leveldb-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c6dcb3d960c1a8c0f8209c6a1cccb147b66aa23f100e14fcbddcb0784bacd90b"
  license "MIT"
  head "https://github.com/liderman/leveldb-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b6978bfd65a0898afff7ad1fbface6880ebcab1154b69c08deb2557bb217f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b6978bfd65a0898afff7ad1fbface6880ebcab1154b69c08deb2557bb217f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb97b6ac6895c7f3063e3696e4e06a332af5a1ab03755a277de29e4956de3d97"
    sha256 cellar: :any,                 x86_64_linux:  "af7613a7bd26dcb2cf1c3a60a5718f4209ec733aa756022b3c82b95068271881"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # patch version
    inreplace "main.go", "0.3.0", version.to_s if build.stable?
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output(bin/"leveldb-cli", "open db\nset foo bar\nget foo\nshow prefix f\nexit\n", 0)
    assert_match "LevelDB CLI", output
    assert_match "foo\t| bar", output
    assert_predicate testpath/"db", :directory?
  end
end

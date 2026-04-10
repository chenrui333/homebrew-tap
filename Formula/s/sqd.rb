class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7a761802a8e80d9a613a149a9feaf8243ed85160e04e451791f975dc7d2bd5c2"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3fb17d694f8ffc53d36d5b38818a6f8f801a3bfd9e1298acc356359f0e0039b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3fb17d694f8ffc53d36d5b38818a6f8f801a3bfd9e1298acc356359f0e0039b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3fb17d694f8ffc53d36d5b38818a6f8f801a3bfd9e1298acc356359f0e0039b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2cedde3ee441194ab874005406d2a4a85c592ad1a5ede1c164952be4576184d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7ebe19644edae15b55de0dc580d49b41a73f693a59d0490cf8f7b009e6e380"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    (testpath/"sample.txt").write("alpha\nbeta\n")
    output = shell_output("#{bin}/sqd \"SELECT content FROM *.txt WHERE content = 'alpha'\"")
    assert_match "alpha", output
    assert_match version.to_s, shell_output("#{bin}/sqd --version")
  end
end

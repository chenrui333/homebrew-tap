class Gitman < Formula
  desc "TUI for creating and managing git repositories"
  homepage "https://github.com/pyrod3v/gitman"
  url "https://github.com/pyrod3v/gitman/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "52525be583585adf0d07d735db753cffd036258acab91190a27d64b358092314"
  license "Apache-2.0"
  head "https://github.com/pyrod3v/gitman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043af19cb9ec7319f08e46ad7b72c58bfb13530e957092612592eb714eb42046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdfc6370d6c957aa4de2fdf60cb36573f6b92b551d025c4a340c4a40d7fdcec"
    sha256 cellar: :any_skip_relocation, ventura:       "8676ca6390bfd9f2e062580b8de2463a31ba0619961ffaacf56be0013630bce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f4e8a03038ecc30ef6443a1abb666d5ffd5724a97a75f9ca1879a325561752"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gitman"
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"gitman", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Select Git Action", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

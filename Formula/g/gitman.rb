class Gitman < Formula
  desc "TUI for creating and managing git repositories"
  homepage "https://github.com/pyrod3v/gitman"
  url "https://github.com/pyrod3v/gitman/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "52525be583585adf0d07d735db753cffd036258acab91190a27d64b358092314"
  license "Apache-2.0"
  head "https://github.com/pyrod3v/gitman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27fcff2b6080b93465ac715c6e16bc003740db6f45d1985be5776d5682c2b601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9513aac425d8987466e77bed4407b0f25b474f79cf5687296cc9b1c837474f7"
    sha256 cellar: :any_skip_relocation, ventura:       "219acb8e09d9bf734e61acac25a5c3834332ca733b44f0d9f1a15ccad1abc657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e5481b5f31509ce0adff296d609b6d8f8044447d810cdb2c8401aab61649c1"
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

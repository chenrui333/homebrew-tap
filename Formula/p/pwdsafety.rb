class Pwdsafety < Formula
  desc "CLI checking password safety"
  homepage "https://github.com/edoardottt/pwdsafety"
  url "https://github.com/edoardottt/pwdsafety/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9c5135d01f1bcbd3db064a9e22532d539da0c36372c4e7044799ebc7bf3801e3"
  license "GPL-3.0-only"
  head "https://github.com/edoardottt/pwdsafety.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pwdsafety"
  end

  test do
    output = pipe_output("#{bin}/pwdsafety 2>&1", "123\n", 1)
    assert_match "Hey....Do you know what password cracking is?", output
  end
end

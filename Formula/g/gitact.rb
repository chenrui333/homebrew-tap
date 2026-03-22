class Gitact < Formula
  desc "Explore GitHub profiles, repositories, and activity from the terminal"
  homepage "https://github.com/nathbns/gitact"
  url "https://github.com/nathbns/gitact/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "518b350ce13c29239672e3a2b49d62c8d61bb74578e38198f82c8ea5868e7782"
  license "MIT"
  head "https://github.com/nathbns/gitact.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match "GitHub Activity CLI - Modern Edition", shell_output("#{bin}/gitact --help")

    output = shell_output("#{bin}/gitact --repos 2>&1", 1)
    assert_match "error: --repos requires a username", output
    assert_match "usage: #{bin}/gitact --repos <username>", output
  end
end

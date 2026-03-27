class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c279f74de81f00afd004337aa79d0508655ab26ddb7b3094a70398bc78a8da58"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b10dd802bc560a074cf9c8fad76b4ea4957b91d45a5c5f02643a806d01e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b10dd802bc560a074cf9c8fad76b4ea4957b91d45a5c5f02643a806d01e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b10dd802bc560a074cf9c8fad76b4ea4957b91d45a5c5f02643a806d01e8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f4817ebed122cecc7a5c0741b54e675f28c34c530a2f39e159a8afb018f5cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fce1bd363cd07fb72f5f6b00006b38c153d9dc74d568ad07ffbaa1a9ee3788b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pphack -help")
    # output = shell_output("#{bin}/pphack -u https://edoardottt.github.io/pphack-test/")
    # assert_match "[VULN]", output
  end
end

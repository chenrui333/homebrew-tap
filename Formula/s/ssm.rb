class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/1.0.0.tar.gz"
  sha256 "73dedcd54e35b8a3876ac7024778594e539b94748ec6c50ba6a685f4eb099331"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ee284fa65fbd2cb6becffaaefa538c77716baf5858bb762f646a50caa51dab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee284fa65fbd2cb6becffaaefa538c77716baf5858bb762f646a50caa51dab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee284fa65fbd2cb6becffaaefa538c77716baf5858bb762f646a50caa51dab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d80f7657df292dbb492f7b4fe7f5eb04c6b7763c65a818406e8bd348ee7bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6a43032b9eb148c0b5fc0f8f042d4622a81758dfda7a6f2ee7152bd114ef2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end

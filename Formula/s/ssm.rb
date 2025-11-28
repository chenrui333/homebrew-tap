class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/0.4.0.tar.gz"
  sha256 "e6be15721429ae654880bc432becc3b80d06cd558e5bea1f2806e408517e5c87"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end

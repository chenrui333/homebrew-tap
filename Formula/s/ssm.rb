class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.3.1.tar.gz"
  sha256 "7402e95d0c2989f80071b25e618a94a08b0e3aa46309cee82a886d111d92f3f3"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb644ddd3f2dca12a36a78e480b267347eef9f62f6118b91398f4462e7047be5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb644ddd3f2dca12a36a78e480b267347eef9f62f6118b91398f4462e7047be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb644ddd3f2dca12a36a78e480b267347eef9f62f6118b91398f4462e7047be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6eb174c201c8bc0c55fc21c4797aeeb667d378cd209cb7dc1734a89b5948043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27d1ab920e142631ea95301a6e6e5b0f324179f53f10a7bf4d64dfcdb17ab56"
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

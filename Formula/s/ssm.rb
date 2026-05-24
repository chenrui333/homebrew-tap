class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.3.1.tar.gz"
  sha256 "7402e95d0c2989f80071b25e618a94a08b0e3aa46309cee82a886d111d92f3f3"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05fa874594e94fabfd71689f7c766f1318542064d080164745f9adab69d7548b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05fa874594e94fabfd71689f7c766f1318542064d080164745f9adab69d7548b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05fa874594e94fabfd71689f7c766f1318542064d080164745f9adab69d7548b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab54e40db7db3f11e815f91ca42303462988605344b395f270605ba0a543fa67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39024d558ba891d5ce5e3104eceb5c59db5d2ce03ba455d3c407f4ee993529c0"
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

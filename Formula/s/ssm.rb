class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.6.0.tar.gz"
  sha256 "342d3359d80d979858b48b0df1047bc93331c229ad1dbe8cb43dc511ab004007"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6903a257a27d65bc1d7461da75d6788b667acc02a4442a8f3b2dda2ad8b3664c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1f0907270b718885a54ae08799f658a15b20b34b7c8a14a5569af4a99fb5959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e89c9ee7293393e646ee2e033f0093eff73e8cbd6354bbb3443e52fc8ffdc60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899cff8d07223c3500873897b74428d3233717318d3c040122a519db629de861"
    sha256 cellar: :any,                 x86_64_linux:  "db90deb94917449f7c1e0a18189f0aff9ce72d049c3038c671da68f3fa22a3df"
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

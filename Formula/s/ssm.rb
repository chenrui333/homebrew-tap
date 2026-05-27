class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.5.0.tar.gz"
  sha256 "b6e32f87ff5cb2811cd8aa06c119aa15919aee94edfa5fd041bfe5c13a9ef19c"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "722277120f35aa8d8a6204c40806d64e68a941881937d437dc37e25f2b9a960a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "756cc6b10292cb5fd8d3fc65a96a436ba6f1a7afdc3a9ac330c1548d6f793ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36eaa3c6a16041f8a96a046b74488ced7cd804f9575dc7882864636fb47ab0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22e43b8919dd75ac639e426e3e18e5fe9ffdd1b328e8a956591af18e817937e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1419dd0b964a88be527784e0fae710aac54fcbee9d85f68ac310422349bc85e9"
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

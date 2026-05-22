class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.3.0.tar.gz"
  sha256 "bd841772dcfd0de0edb1c9fe14cd09b0bc5030ddb5be6411b87a5d6bcfcfaaaa"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5a379dd19ffbabfa5fe80478c92f19db8ef19130961147ca1a35a5c87535626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a379dd19ffbabfa5fe80478c92f19db8ef19130961147ca1a35a5c87535626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a379dd19ffbabfa5fe80478c92f19db8ef19130961147ca1a35a5c87535626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42f32946c413a3420306a58f1cb75baf82e30339dd9479d9b55a8e73bde849d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fa9c8917091779799154256b29b6e93e0b8521103f93801a02ddf62f4cb00f"
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

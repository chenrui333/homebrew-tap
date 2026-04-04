class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.8.tar.gz"
  sha256 "e8d7d4ffb10287ceabc5e04591b2642ec931730fcd025be860c96307229700ae"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8df44583fa9bfd5666e4a3db7de698b46aff596717ded5ed4ebf92391fa6f3e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a025b1377b92ed063cdbb518ea21d933b38c0b3092da074006bd1daa445a409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5012caaa36a3d04a801149cd97b5f1c02abde532c02974192ee5a8a036173178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7f1ec7c7155a489081919255f61af489b55813815cd71bc23f0599ec6c0646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23a23caa77f63d5a1e14239cdbf583d594f70d64b30f3a7b97bfd1569e018cd"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cliamp"} --version")
    output = shell_output("#{bin/"cliamp"} search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end

class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "63bed79645469670f05b579a3812a71d39c774c02499b78e135f5cb8aafa010f"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f21a2351f4940281aaa4459e1d08ec273da96fd16bb38dc553b581162268f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f21a2351f4940281aaa4459e1d08ec273da96fd16bb38dc553b581162268f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f21a2351f4940281aaa4459e1d08ec273da96fd16bb38dc553b581162268f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60d5d4538dca1395a995ade574cb5d0467acd2e538c18a57d109a32ad87f3886"
    sha256 cellar: :any,                 x86_64_linux:  "f2f17907054dc84f39a399e6db562ae75be9ba3138605d9672ba22a6bed38cca"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    ldflags = "-s -w -X github.com/xdagiz/xytz/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"xytz"} --version")
    output = shell_output("#{bin/"xytz"} --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

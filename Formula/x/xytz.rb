class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2c48bd2925189660d884e290a60ec9db823ef39ee31a3fd0aecc4c3036f69ed9"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08c926e6b7ac10b579d4125a3d6b32d2f91af0d4ae8dd53629a18e187034d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08c926e6b7ac10b579d4125a3d6b32d2f91af0d4ae8dd53629a18e187034d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ca18f3105714b01a3f907f63c31d50e5416d6c26681cbc8b088a552ceccef6"
    sha256 cellar: :any,                 x86_64_linux:  "4601de953cb5bd28193a943d11dc4e7549c3421aa07f390dcdf6d701c1c06f9a"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "a58eaf4577d717c128a8d461185bff0e73e89c219747602341676b88f712e67c"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e26e58c657a9408f32e9a357776494f8f5abaa60a558238088a9bb60c06f6f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d38537cd343a61ded62666bdcd2b3a831b1b18df84b3e649d49eff937b636894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b6b7f0f6bccb2fb5a0d136e36687c513287f7451500e6458766151970da554a"
    sha256 cellar: :any,                 arm64_linux:   "03b0cfd5ceefa11bb787b3fbca77eedb167cecf80326b307cda274dc94bc06fb"
    sha256 cellar: :any,                 x86_64_linux:  "c7556458068aa9a504f80dce6c0fa4b25fb3ff20dc4e10869a08b18845330afa"
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

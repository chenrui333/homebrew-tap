class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "4d93784711c1ebeaed11406f298c93a65d5cfcea2a10b46ca9f553f6db7883a9"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06e6311dd37deecd44a7bf4bcd5435ea6173b1f959c50431dd7c9b0ecc7e3659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8279a982f4907a67a9a8463a10d08c120d40ee607a1e9eea760f89bf828681a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9eab87647cc63ee2adf5bc1cc6beb2653dd94855cba5a3eaefba6ea35d15c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57d172fba44b06e4eedd1f46b14a0ccc97c473b92287c5f776e4df60f81b4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef5fe65117c75dc633bdbdf7a559596480a5e335c3afd85c4a0a092a0663250"
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

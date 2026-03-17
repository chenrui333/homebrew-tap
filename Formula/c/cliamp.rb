class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "270551ac83e02186a86717ac35e73eda2efb1c7c165f150f8efacf5ccbb04435"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a64e5caec283d9ddd6108c5aad291442139819bdd210522a2cf90b6738c913d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc3ad97c827000ba7c30b128146ad756f44c72d8f764c0096b0fb7fbdf58754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5caeea916f91cadd2eec3b787522638d48ae1baf8e9d09bdefdf037bbd5d3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad1645f5637fa1bbca215aa1d5d4f952b99402099f2aa3b817836f855d33f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13ae0ca92b62991d7275fda04e9e7115bcbf5c2c186d1ea89e5fa795e77030d"
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

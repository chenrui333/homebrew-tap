class Spotifydl < Formula
  desc "Download music from Spotify with complete album art and metadata"
  homepage "https://github.com/BharatKalluri/spotifydl"
  url "https://github.com/BharatKalluri/spotifydl/archive/refs/tags/0.1.1.tar.gz"
  sha256 "ece91673c8cd2d8b6cd89610cbfdf6e1ef4dc1e15fae8aa120e9d1acb8fbfbb9"
  license "Apache-2.0"
  head "https://github.com/BharatKalluri/spotifydl.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"spotifydl", "--help"

    # `Make sure you have youtube-dl and ffmpeg installed on this system`
    song_url = "https://open.spotify.com/track/4aw5XZ3wy5OKfvWkl063HE?si=5e12c2b1b270459e"
    output = shell_output("#{bin}/spotifydl #{song_url} 2>&1", 1)
    assert_match <<~EOS, output
      Found 1 tracks
      Searching and downloading tracks
    EOS
  end
end

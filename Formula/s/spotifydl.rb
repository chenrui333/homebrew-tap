class Spotifydl < Formula
  desc "Download music from Spotify with complete album art and metadata"
  homepage "https://github.com/BharatKalluri/spotifydl"
  url "https://github.com/BharatKalluri/spotifydl/archive/refs/tags/0.1.1.tar.gz"
  sha256 "ece91673c8cd2d8b6cd89610cbfdf6e1ef4dc1e15fae8aa120e9d1acb8fbfbb9"
  license "Apache-2.0"
  head "https://github.com/BharatKalluri/spotifydl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb9e8bc1c347437c11a9df7b78e0381ecb7cc63fa52a5083dcbc53dc374ae108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea796d3cd70f99286c31fb92a22b68cb7544672e6748777d2553f5905bd8a35"
    sha256 cellar: :any_skip_relocation, ventura:       "c1a5956413e050059f8120936c890f3d456e5c23f95ba6f6c621c0fc7234b92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe5faa92f07eaa7f0067fde37868dbdba2d69035f6023f9c123de4d60b290ee"
  end

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

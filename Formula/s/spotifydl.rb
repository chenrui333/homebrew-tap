class Spotifydl < Formula
  desc "Download music from Spotify with complete album art and metadata"
  homepage "https://github.com/BharatKalluri/spotifydl"
  url "https://github.com/BharatKalluri/spotifydl/archive/refs/tags/0.1.1.tar.gz"
  sha256 "ece91673c8cd2d8b6cd89610cbfdf6e1ef4dc1e15fae8aa120e9d1acb8fbfbb9"
  license "Apache-2.0"
  head "https://github.com/BharatKalluri/spotifydl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdeb9586bc5222b235abaa774aedf464e610892cfb56975f784fbfecb1bf9161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdeb9586bc5222b235abaa774aedf464e610892cfb56975f784fbfecb1bf9161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "910c9b7de36f962e6f3752e00fdcf528757ebd8e297ed3d2492c23168804dec6"
    sha256 cellar: :any,                 x86_64_linux:  "cc0452eec53d5da2b6e4756d54c64b1d24bb2ab2b4399266dbd4dc72cce8a15d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    # URL validation happens before any Spotify API authentication
    output = shell_output("#{bin}/spotifydl not-a-url 2>&1", 1)
    assert_match "Please enter the url copied from the spotify client", output

    output = shell_output("#{bin}/spotifydl https://open.spotify.com/artist/0OdUWJ0sBjDrqHygGUXeCF 2>&1")
    assert_match "Only Spotify Album/Playlist/Track URL's are supported", output
  end
end

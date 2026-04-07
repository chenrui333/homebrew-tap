class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "931825fb7e1e9439019ac0d486a913e79cb667dcbbb88556485030ccab18eca5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ed98ad72e0e28d12aaa6d395fc5e975d0b93a23a6a8d1acfb130005cd56d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b62a764ee26c75850cea93a52158c9fb3ae7867efc401e664e78708897e68629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f96af9b7394d57482fd67dfe2238a7c2a9edfd44a84529a75f76a4a37211a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aebfbcf77150d0c3115f6f1a4c963867fdbeca7c9701ee43f2e0bd9bb78f9396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc040bd71aae008815f2ffbd9d6b6c7736f8c06ca13c1622687aa5e5c171b9e"
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

class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "6673f275fc3943be84eba33a5ad760d9bf781c56cdce928d16ae3445c09ec220"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c49ce9846b7906713dece3505217eb88cf97ac509b547d2d47e3261dfd94607c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f98814c6235c67ab596759eeec3b7079b01199ce85da615ad89fd151e81f91f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "776fc86b7756f003a9762eb7c0b17aaf3ec752a3aabd145ed3a3b0ee93ec4ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19510a2a30f5991e3e0b2008a3f8a5790d07662251f33f7de3adc435bf5f687c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a68cdd9d324ae2a9bcc2cae392a80ab3507a7adf7f3611d2e6b7e9346cf0692"
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

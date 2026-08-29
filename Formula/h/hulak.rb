class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "082d5ab2d036238fa2a008b502a4b01bd8b23935c40c50fdcc2ed16918a4f840"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "694525c065e681201f75297b109aac24bd715d8887aa697d55d1416883f08943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694525c065e681201f75297b109aac24bd715d8887aa697d55d1416883f08943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694525c065e681201f75297b109aac24bd715d8887aa697d55d1416883f08943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c378ee46290b30f3fe532c61dc1546a81fa4a9b694dd55690dd235bcd4c162c"
    sha256 cellar: :any,                 x86_64_linux:  "4ef392dce98b2329f5d1a79700f469959977e78ebe4f39802cf60be73a671952"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")
  end
end

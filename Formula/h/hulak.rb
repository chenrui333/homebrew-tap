class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "082d5ab2d036238fa2a008b502a4b01bd8b23935c40c50fdcc2ed16918a4f840"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d458a3871f1f007a6b3a47cbeeaae42920ae2d82065fd08c3c559a8c0de70830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d458a3871f1f007a6b3a47cbeeaae42920ae2d82065fd08c3c559a8c0de70830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d458a3871f1f007a6b3a47cbeeaae42920ae2d82065fd08c3c559a8c0de70830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ff6bcc26a59c7a52f41d432bbf2f2ac5512e93625bc3218e3ec3f3235f00314"
    sha256 cellar: :any,                 x86_64_linux:  "54c8b6e7379036571c90ef9d2bc2f151534038b9705bce84fa2e2cca82e4d3cd"
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

class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "151516902772fc94b5f0c3b591dddda0f49c832a5f2e50836184fb235d554815"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48fdc87ec106265b07bb4eafb86e9bebbd828840e8b1057d6fe7e69f71360cfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fdc87ec106265b07bb4eafb86e9bebbd828840e8b1057d6fe7e69f71360cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fdc87ec106265b07bb4eafb86e9bebbd828840e8b1057d6fe7e69f71360cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026aca6a5be4d5e5a8724b60de4ff0cc0f638b87c33218e9fa2b905b126dc4f1"
    sha256 cellar: :any,                 x86_64_linux:  "eef56ceb141b8b5552bd88f40c9e6d35727a56ec22539813a817ffba7d23e1a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end

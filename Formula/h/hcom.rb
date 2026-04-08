class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "36e12e039481d9f739892130dda4dc889ddf9cb0da46d32c11a250f8c7f43195"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6c085819d10a5e68b7448febc3dd28c2ed9a29eb9cd949a72f38952343ccd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b0301c61ea73c1386337024f1dfe2ed0d23ebcb288ce6a18a4587a771511e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "470359123dd5807b7a2a7e9d4e50b9cbeb2c37e40f257a8ae4aa9d2784b8d824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c543dc7c794e78cf091898ccd03dfcefa6181f03de74aac25ac5420c8fa39f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77ec4469e1fde8b7dce638deb8a767e2b0aa7bf97a06d1a0741f1b8868c09ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end

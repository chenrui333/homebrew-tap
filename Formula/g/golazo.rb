class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "6c7287e308fbcd7041e55287ab77fb86a808e925e176429ba7b1a82a9aba79b0"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce26f57dae7c3f318aa33f107452e35445379a9d1fcce933ed95b7929e114d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce26f57dae7c3f318aa33f107452e35445379a9d1fcce933ed95b7929e114d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce26f57dae7c3f318aa33f107452e35445379a9d1fcce933ed95b7929e114d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222a01c6ffa828c9129d1b34bfca3a0e000defce8e72ef3eb5e9a071136a607a"
    sha256 cellar: :any,                 x86_64_linux:  "c1649451018242ac6ef7f6986adeb64ece86acda5d9b935b730347f83312ff7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end

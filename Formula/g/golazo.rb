class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "6c7287e308fbcd7041e55287ab77fb86a808e925e176429ba7b1a82a9aba79b0"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f0fead039dc878bc7ef2c457644a11045037b66fa344b78527b503e7ea3629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f0fead039dc878bc7ef2c457644a11045037b66fa344b78527b503e7ea3629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f0fead039dc878bc7ef2c457644a11045037b66fa344b78527b503e7ea3629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "434125005b1d73ce3bc3ce03b6ddb9505384b2b10cd8ee727a81b9654b886f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17ea12f88e5e79c1b2884b216ca4b14a0fe6f9e0dd894895cd621d103946b98"
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

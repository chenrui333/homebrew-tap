class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6ccc10b8f2eb8449c2583e966e0e331bb7e748d3cc560e254ea404d5c7a9c926"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e5080412f52272eb7da6445123c43d15f0ac4d594079c1178eedb9d715ee63f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5080412f52272eb7da6445123c43d15f0ac4d594079c1178eedb9d715ee63f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0456b46e4136e594469b017f5afbe9c79bd1845c5102202092613c309be81a1"
    sha256 cellar: :any,                 x86_64_linux:  "77af7a19e780777a77c283480181ba2c46f951f2d875f28f98e7417179133667"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 2)
    assert_match "unknown flag", output
  end
end

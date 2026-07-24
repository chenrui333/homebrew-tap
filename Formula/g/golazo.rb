class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "dbb97b01853ae003b2e99d8e608d05f0c71bd65f18de38b41308ed4d2a47c33c"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a601ccc04b70b89b5d0dc6b485dcd8b1000a65f7b3a793cb450585c9ecff718e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a601ccc04b70b89b5d0dc6b485dcd8b1000a65f7b3a793cb450585c9ecff718e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a601ccc04b70b89b5d0dc6b485dcd8b1000a65f7b3a793cb450585c9ecff718e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18b78c2d2a9c8e3920fb1cfafe12089b40c55560fa24d8fef67233637f34043"
    sha256 cellar: :any,                 x86_64_linux:  "f455c5922a212826fd7c596a7bd7b836f25b7bf536f82f15d79187185a3a85f9"
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

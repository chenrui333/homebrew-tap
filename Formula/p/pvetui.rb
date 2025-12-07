class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "dc6e721e8f551159ecfa4f6335c691e4cd13e909ced314f0f9e514227191ff78"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "729740b059528bd9a4a8dd2294f99574fb199f7dbb61c0ec69a74fe5fc350b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729740b059528bd9a4a8dd2294f99574fb199f7dbb61c0ec69a74fe5fc350b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729740b059528bd9a4a8dd2294f99574fb199f7dbb61c0ec69a74fe5fc350b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d71535cac4a64b1de9ac29a6601cf72d0915002b80cbdd0a997394ae59c9f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e89b936eef4e9e1d3eb8e8b168ef2d551b858ef1d22d889a4e806dc7455ba9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end

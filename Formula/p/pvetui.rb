class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "78ae87f537328c25859856eff994696ca3204bda752b56f23b206f7aa08183f3"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d499f190ba847506b8c6accc442d97198323fcec44fbecee720a06f6c7a1a1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d499f190ba847506b8c6accc442d97198323fcec44fbecee720a06f6c7a1a1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d499f190ba847506b8c6accc442d97198323fcec44fbecee720a06f6c7a1a1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a220cf83894b52f781fa0a24fac8c8a5f505e4d05d011dcfb3430c126381cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed806cfc5c9bee733b532b1e15319ace63153b883150c0076c90e902a36cefa"
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

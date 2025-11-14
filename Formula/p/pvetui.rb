class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "78ae87f537328c25859856eff994696ca3204bda752b56f23b206f7aa08183f3"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc60d1711130e58dd01607e1154f7b456d9e0ae64d570069492d017d3b500757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc60d1711130e58dd01607e1154f7b456d9e0ae64d570069492d017d3b500757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc60d1711130e58dd01607e1154f7b456d9e0ae64d570069492d017d3b500757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "346df6b1ea6a8a72cc2a59b22911cafc265bd307f6b92e158370a1600fd54cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd89797285c6599cbcee8236369c1f9b36fde245fb9b14ac4db3f9913751d307"
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

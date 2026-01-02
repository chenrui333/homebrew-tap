class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "33e3af93fbcee6a6fe8687158c97b0a3f43a3bfd3831cb92d3efc63382f17de7"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8847d86527beb817775696b473de756e0af327418057c3a5d727f17511fa0f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8847d86527beb817775696b473de756e0af327418057c3a5d727f17511fa0f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8847d86527beb817775696b473de756e0af327418057c3a5d727f17511fa0f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44277790e61ae353c3cf73f643dc6b5af39b600e92bf1be6978bb31cfced559f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ded9303dc23e1ec287b4f2ef8a9f751487356f4241770e34841f0ac3991dbc"
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

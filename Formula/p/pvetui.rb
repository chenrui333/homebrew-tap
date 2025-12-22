class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "6be2a3937d0e7943d04839f582780cf814323744b06ce96923d2c7725bdd8368"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aae6e76ec4ddda07fefa3b59d9ffa78f67080af5d13c8f61737efe1a50290d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aae6e76ec4ddda07fefa3b59d9ffa78f67080af5d13c8f61737efe1a50290d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aae6e76ec4ddda07fefa3b59d9ffa78f67080af5d13c8f61737efe1a50290d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebdc2c2a022d2bdb78ae5c8feccc3f67e5d058c53b9c5f42ecf83ec6c5d5231c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df29fadef5797c66b4435baf9e1007cec95ccb8a1356f73882b645314d2e77ec"
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

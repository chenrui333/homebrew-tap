class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "6be2a3937d0e7943d04839f582780cf814323744b06ce96923d2c7725bdd8368"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eba3c54c5db2b85a872b48496b9bc346155bc133f6d0078cf2632ab040b1340e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba3c54c5db2b85a872b48496b9bc346155bc133f6d0078cf2632ab040b1340e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba3c54c5db2b85a872b48496b9bc346155bc133f6d0078cf2632ab040b1340e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628ddc06b3b36eed7d8d6ed4dd03c7a294267ccd519d13f094356a550e1ddd20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47aceeb65e1a08c6935c2299456947ac3539eb43c91d27ff530d0999e930a92e"
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

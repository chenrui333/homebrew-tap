class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "14ede4be687a2f34392e87cdedaf937c291f091fc5a9ca6b7d52db8634f0343f"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44da25c36a364669848aaede98ff9f4be454c990c6e42646c6c11cfc3064dc47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4e068854443e5bc59477db711009d5213d7e835b9c537d09b3d11e6892c277"
    sha256 cellar: :any_skip_relocation, ventura:       "18c7ef3ab79275819ef0dfd2f840f937809bfcdd24b1b8ca91bd8ad11ae660ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971aadcc8b1692ea00467db993104af304f295cbc43652b7b44f24bf110cfd97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end

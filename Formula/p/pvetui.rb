class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "f1ab064c230316d53487b8c723f15f8089fe07d07431f652ab08ce24ca4b714d"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985ec29388b94d90226ab19040fc3521610c8cad754fc87fff45df010ca8d7c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985ec29388b94d90226ab19040fc3521610c8cad754fc87fff45df010ca8d7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "985ec29388b94d90226ab19040fc3521610c8cad754fc87fff45df010ca8d7c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d5b4c3a6272b18ea297c17a3913924f30d26efdcafb5fca798adc5d8205988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51483dc503ba7037a9f4cc41072545d2597c46780b0a52c5bf38382101d62a8"
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

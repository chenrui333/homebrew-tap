class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.88.1.tar.gz"
  sha256 "eecaabf137957c84e1e88a8f867af862118d249d57f65f7cf93a2f6991393f53"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddddc0c01c3dc5d24565d11c71b75d82b31904c20d797984efabdabb860a526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec5e02a849acd3dad49de978062919df1ff3078d8a9a00ee9c9542956a51adff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685bb14a93e713e82c5e6c3b7e187c733fde9c017f6341ebe63725b5c86066fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "864613dbf4e410076aa63339a7d346b24c5e1c4959753d4d79c7e4d8f49f2c32"
    sha256 cellar: :any,                 x86_64_linux:  "bf1570b30f9099f710de71909bfd153aa18f943b2730e08d14d53c7bce191ff3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end

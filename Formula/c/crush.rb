class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "ab8a95ac50801640ea3fd92fc421ae10caf82a8eda7ffc1b38721af5fb481520"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f2d059486a58fa22ee6694917ef8ce8732e3b95c4d9e72cadeb048769cd3c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aac4832d9d9d9df239766a7708746976a78fd89813ab17ba468486d61603682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6683ea878f2dc90a5f8c7043f761b7effb0d50b8720b9f5df4f20810232adb3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54790c556328fc90f27d6c5010c519f48de966d49f80624a02dc9e94c1473ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3adfe0c733ba3a61875079215e75001127f1ec545c9e0e99b33c9fa895be2ea8"
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

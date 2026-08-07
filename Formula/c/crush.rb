class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.88.1.tar.gz"
  sha256 "eecaabf137957c84e1e88a8f867af862118d249d57f65f7cf93a2f6991393f53"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c00e2d8e8a5f32b306d0b191b38a1c9b02baae517452f0e68e60f2905afe17c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e86d7a5b1393a3c387d861f957823525f47f7664d00b3ebe860ce9f635c272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f9c2ab72bb333d2144071f070fa0b29bd7dd5b9183399301bcac91c43bade1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d327a7197166149ebb4536504ac1d9201d1e650e818a5159afc5784455a966"
    sha256 cellar: :any,                 x86_64_linux:  "705606f6f276ecd2238d089ee332bea725b5a293330bfbef31d27cb474e9ff45"
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

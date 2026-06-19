class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "638650101b9deee120a9bdd3273c522672cce70173901ae26dc6e6a3f83a563c"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de7178c140cbec9ef61d74c2fabd897f381575840f61c5cec809182cc5253c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900cb27410f1d15a00462fafcea105357093a87c114bea847a10c903b7e92ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7baa65526e70e2705bf5a4b7f5cded96fe9bfbd15cf44d6ae8f31da7570d214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc9cda3915a8e9dc2ff12edf0e3d0eedbc2807156bfae24cfbb685ae260e65f"
    sha256 cellar: :any,                 x86_64_linux:  "1ebd08f04664de402ba583a30dc1e760bde064c7c4ba54dcb228629ed7877669"
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

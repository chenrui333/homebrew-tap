class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "0ac66bb3df675cb21e9b3d95303d6170e034faf3fc998bb9ac167af8f4409e95"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc7579fdbf699876dc7acc0502791d54c982321e21b1816b15b3891e348c0d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d347a08ace6ab7cb7b83c41e81a92d9e39443411ee71cd9c1cc54e57ddd16531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e829fce28cf556cb7c118015144ef8cf412f34dbe8acede4226b0b6efd2865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d32fb354ef420ea1cc0fa0d28313ba314716ae290fef5dfdb1203bdb4b7a6902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9956040258fc1ea7fa7a9fb7ad880d0517f6bda9f4ab74db3b615c3dba2bbeb4"
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

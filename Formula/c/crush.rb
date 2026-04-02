class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "cbf7a3661090cda958b96c087f8a4be2a74f24fa78796fce1b265287cd74e6cc"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9705ff8c48720d1600ba2445bd5b521df988362ba440caad64b28a7489c19a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45dbcc0ae82d2d1e0b8ed9ee99513ebe529fc5b3b841aadbe220625ab2c2db18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d21ddd137eeec0aa1911e9c7b0aa8411dd61ad00e5916ecff580f9a7fa42397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c6acf70d53dd5ad765bf74417a1ef345bc71c55ba259b2977fe99778264a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e37346a3b6a7eeea0fc5d345421c9c1ce9f8ef678e7ae7bf4c38395f16f4763"
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

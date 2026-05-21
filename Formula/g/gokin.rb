class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.84.8.tar.gz"
  sha256 "9230fd66070e63a2910a54cd2cedf65bd87a9d5c416761ad42cddcd5fb697d3a"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b73d6b19a9a7e1a7dc03112388d1acf24e073b34c6a966ddcc538a751b8e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b73d6b19a9a7e1a7dc03112388d1acf24e073b34c6a966ddcc538a751b8e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b73d6b19a9a7e1a7dc03112388d1acf24e073b34c6a966ddcc538a751b8e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53254fb7a4a8ba735e06d768250252024f643135f09dc4b6d3206a9247acdd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3388469fa067de0edf0ebd0c804c28498f6f854232df2586f3dcb59c5b0f349f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end

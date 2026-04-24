class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.71.4.tar.gz"
  sha256 "a7460b593a0cef2b5b69aec564127192a1e6951a285c90a37aff833bad156e47"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1fda609e34347c05f4cadbc0cd8eab81853a14ec307c6d81580b30bf7457b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fda609e34347c05f4cadbc0cd8eab81853a14ec307c6d81580b30bf7457b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fda609e34347c05f4cadbc0cd8eab81853a14ec307c6d81580b30bf7457b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6edc8be9ee8211187d3b3089a02b930999d92a1692d3cc9345b7384915e078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9aee24db60e45444336e18f4cd7f95e8a4195acb33f571f70fcad6bbd350549"
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

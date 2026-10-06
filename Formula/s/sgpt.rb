class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "b2b295584850181171ad8ed618028fbb5ad1ea11f02d3d2efe7defe0be78bed4"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6430b7b6fc48cd7b2d8bf022b222419ae4d1866a83f0014ee384bb7850a13689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6430b7b6fc48cd7b2d8bf022b222419ae4d1866a83f0014ee384bb7850a13689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "207bfd73e06dc1edf0607a37b007f8f2027b9ef822ae37bf91391151e4c944a5"
    sha256 cellar: :any,                 x86_64_linux:  "50bd796a377414903bf5c020ab20416143dc9009f990a3c3a0dd4620d01dd5a1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tbckr/sgpt/internal/buildinfo.version=#{version}
      -X github.com/tbckr/sgpt/internal/buildinfo.commit=#{tap.user}
      -X github.com/tbckr/sgpt/internal/buildinfo.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/sgpt"

    generate_completions_from_executable(bin/"sgpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sgpt version")

    ENV["OPENAI_API_KEY"] = "fake"

    assert_match "configuration is valid", shell_output("#{bin}/sgpt check")
  end
end

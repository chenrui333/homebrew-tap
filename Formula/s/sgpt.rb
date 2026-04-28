class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "eed6d5b641c95c2fbc614790e97c43ed17f630043b1bb483c1253ce9acfc2967"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0fa82ebecf8524e78b17afb79a124ac52773325e14aa6634b4ec7a5e59abd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155b08b8695383aaa24fe869b5b9d996c5eafc5aa6986f17d6812e9a18874fbc"
    sha256 cellar: :any_skip_relocation, ventura:       "3ecb88e222ef0f79122cc46cdb7e4911c6ad18e1bcaeed49bc879430f5f6dd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b3182df0af9392e84e7f704bc5e63685fbecea4c69166eb4d435ae32ed59df"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tbckr/sgpt/internal/buildinfo.version=#{version}
      -X github.com/tbckr/sgpt/internal/buildinfo.commit=#{tap.user}
      -X github.com/tbckr/sgpt/internal/buildinfo.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/sgpt"

    generate_completions_from_executable(bin/"sgpt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sgpt version")

    ENV["OPENAI_API_KEY"] = "fake"

    assert_match "configuration is valid", shell_output("#{bin}/sgpt check")
  end
end

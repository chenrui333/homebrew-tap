class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "b2b295584850181171ad8ed618028fbb5ad1ea11f02d3d2efe7defe0be78bed4"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e9a603ec02ae7bc941abd32ce514097351d03443c9c6993d066cbc59a4d132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e9a603ec02ae7bc941abd32ce514097351d03443c9c6993d066cbc59a4d132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7e9a603ec02ae7bc941abd32ce514097351d03443c9c6993d066cbc59a4d132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28bc7c850c48606cd908b702925875f4ea8540ec9c10857941bb97737d34d96"
    sha256 cellar: :any,                 x86_64_linux:  "78e468bf8cc0afb9f6fbe4e17d99af85ba7368bedf2ace2e65e107b857a8bad3"
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

    generate_completions_from_executable(bin/"sgpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sgpt version")

    ENV["OPENAI_API_KEY"] = "fake"

    assert_match "configuration is valid", shell_output("#{bin}/sgpt check")
  end
end

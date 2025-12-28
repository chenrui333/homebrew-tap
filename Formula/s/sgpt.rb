class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "d02c1e3b12dd40cc22a5741e3a90f359123fd6f37d6e56c63f6a82e12507dfbe"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca535b634ed1d42f3747411d4be368b858a408699722669a800cb3e32d74cda0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca535b634ed1d42f3747411d4be368b858a408699722669a800cb3e32d74cda0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca535b634ed1d42f3747411d4be368b858a408699722669a800cb3e32d74cda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1785597d83ebadc8a56b295667d18f892c5755db87aef7ece6b25a10e927921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4330f40f4af2b52a1b7bf7e879c7e5cb9d8eda67c774fcb7d55c571a5e8df1ef"
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

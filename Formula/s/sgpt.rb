class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "a57259f28ad5fec62b2b2e8171768e368aa43577ef7de049e63b2f3f63b2bf1a"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6f6332573fc1c3614395564e9f53cc389bf2f7b2a941713e9b2bdb9b8da2f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6f6332573fc1c3614395564e9f53cc389bf2f7b2a941713e9b2bdb9b8da2f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6f6332573fc1c3614395564e9f53cc389bf2f7b2a941713e9b2bdb9b8da2f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8525a142621b2c084b218c98c638a9fa29b7de0b778345cd6b9499bcdd6b984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8c2bf033990eae29b44f7efaeef1f2b2ba1d131e512471dc8846599822e2d2"
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

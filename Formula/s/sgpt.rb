class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "a57259f28ad5fec62b2b2e8171768e368aa43577ef7de049e63b2f3f63b2bf1a"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28d63c69a903c864592bdc7ec6f95a94fcc7f2cc2e41dbf02cae5a5e0d689d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d63c69a903c864592bdc7ec6f95a94fcc7f2cc2e41dbf02cae5a5e0d689d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d63c69a903c864592bdc7ec6f95a94fcc7f2cc2e41dbf02cae5a5e0d689d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3c9162418584151ca7eadc5de8467fe4266ec92c54eb1fef763322a32a37e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54262e92c41aee344f3247931f6521f110603a7dbd637f259608242ef148c559"
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

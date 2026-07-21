class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.21.2.tar.gz"
  sha256 "d988d090a5fd095ae508d5e6d32596bb37521a2d1f24dea8a71adc1c4a920f61"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6087d0d564d4608272967640ce13fdd6c87f22c9fcb1e70d06954dae4aab3654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6087d0d564d4608272967640ce13fdd6c87f22c9fcb1e70d06954dae4aab3654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6087d0d564d4608272967640ce13fdd6c87f22c9fcb1e70d06954dae4aab3654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aadf62272f9192d97737525205b7631efda68950da547aef2c0c544f6d056341"
    sha256 cellar: :any,                 x86_64_linux:  "219fde2a7bcda0688eecf68509fa5d3cfd471079b0eabab68bf6554fad35aad5"
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

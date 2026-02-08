class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "1f5137f20b81e7f58229ee360fd958344420d82fe5ac18af78ede6762c90c5c7"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd3077305a5f09f48b5e46bf9abde4deae5c14211d1b631853562ccd1a642ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd3077305a5f09f48b5e46bf9abde4deae5c14211d1b631853562ccd1a642ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd3077305a5f09f48b5e46bf9abde4deae5c14211d1b631853562ccd1a642ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "856c5c92256e56c72b89afd69055251d94cd641c66a19e05ec2f32f209f21a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa80f322415ff318abcb377f0aadf500d0bef127a6598a0ec0879e14c23ce25"
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

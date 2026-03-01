class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "74552a21d3bd5da0e2ff7a8a525b85b61d8a76c6342f99d72c5ad0835e7eec24"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d732ab792d52f4a921cc92ec5fa23c65bc5c16dd1932525bfa5b6e2eb83ffbed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d732ab792d52f4a921cc92ec5fa23c65bc5c16dd1932525bfa5b6e2eb83ffbed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d732ab792d52f4a921cc92ec5fa23c65bc5c16dd1932525bfa5b6e2eb83ffbed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "942f55afe6aa0d2eaf8e4113eae315b65e6985bddeb153858aeb3749c342e3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cd57dbed4ac1dacf9b55e8f728c6af9b2ec99dd25b502aa871d064da036764"
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

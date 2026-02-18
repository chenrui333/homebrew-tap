class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.6.tar.gz"
  sha256 "7cce09459cc9ddf1c81632ca9b8074dce53e1626caa28efefaf38905b91e6ff2"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3392fce2094cf0c1fdd884f2c050381212c9f41e4f72f97633f3871b2914ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3392fce2094cf0c1fdd884f2c050381212c9f41e4f72f97633f3871b2914ea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3392fce2094cf0c1fdd884f2c050381212c9f41e4f72f97633f3871b2914ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00026a3cce4456fc43d70d8d47733f7c1415a80b84affac318d23c15b266dd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c98cd4b10c6f2885a822f9d60f396564005ee9b9d60637acfd2e9d1f7431649"
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

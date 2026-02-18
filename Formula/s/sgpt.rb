class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.6.tar.gz"
  sha256 "7cce09459cc9ddf1c81632ca9b8074dce53e1626caa28efefaf38905b91e6ff2"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ecc5f08c28e8d110147b2b9eab900d8c16d422e42dd33c99341a426f72e64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ecc5f08c28e8d110147b2b9eab900d8c16d422e42dd33c99341a426f72e64e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ecc5f08c28e8d110147b2b9eab900d8c16d422e42dd33c99341a426f72e64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea0b821c62c77fea6ed3fdcbd77b49e82783fb8e8be7e70bd2798daadccc42b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0805292fe8ca56c81d29deda7cc7e097834f9c1565576de93a5054219bab4f4e"
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

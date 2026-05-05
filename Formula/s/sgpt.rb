class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "323fdd247247f1f9fd72ef80446266c854e5de52887e815e70c93d5310343aae"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741fa35cf01e464dccd0aa44941660761edcd15a5e34a90dd0ff755924b245e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741fa35cf01e464dccd0aa44941660761edcd15a5e34a90dd0ff755924b245e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741fa35cf01e464dccd0aa44941660761edcd15a5e34a90dd0ff755924b245e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31cd3dd9a088023745666f91a32c2c09a64f1d6c6d6d08458afa54bbab060e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6602705fb96aaa1e457207f87d295bcc046d0e58137f2e1ed0af540dc39a751a"
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

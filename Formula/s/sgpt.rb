class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "d02c1e3b12dd40cc22a5741e3a90f359123fd6f37d6e56c63f6a82e12507dfbe"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a589de550e22cfb923390116351111c95bfa2f461dc9e41518a3fd08002390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a589de550e22cfb923390116351111c95bfa2f461dc9e41518a3fd08002390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a589de550e22cfb923390116351111c95bfa2f461dc9e41518a3fd08002390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6cfb8c1f20fa2da6b1e967ae95fd59b40d0d60bf9573e8753d3d9759068d031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835031f9117cc14b31093d1eb63d133553ed135105eb46882e5b9f41a343e768"
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

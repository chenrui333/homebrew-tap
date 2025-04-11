class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "eed6d5b641c95c2fbc614790e97c43ed17f630043b1bb483c1253ce9acfc2967"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90ea0450e0b21e19d8d2df62d23e653eefca5d8e546d5111bd8ccc05b010c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08f31c397b695477b8e1fecbd39dd034cef0d3b90ddcaa56a25b9b7c2d688aaa"
    sha256 cellar: :any_skip_relocation, ventura:       "084cf389332d3e3e494f0c508dae45f3af4101375adaaca28df9b4cebe469219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbae36f67cc53e828943ccbe1e5e3224e088fd76852010f871f3e8299962690"
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

    generate_completions_from_executable(bin/"sgpt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sgpt version")

    ENV["OPENAI_API_KEY"] = "fake"

    assert_match "configuration is valid", shell_output("#{bin}/sgpt check")
  end
end

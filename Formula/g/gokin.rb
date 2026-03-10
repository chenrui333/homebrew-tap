class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "fbadf693bed6f4e0f15130861ec9c1fe89db801bf0648bbdd891402fed42a5cb"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49a4a024ef03d0de6d354ca5a9a1b0bde8931902cd0b784ee0389a222d507f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a4a024ef03d0de6d354ca5a9a1b0bde8931902cd0b784ee0389a222d507f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a4a024ef03d0de6d354ca5a9a1b0bde8931902cd0b784ee0389a222d507f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d14839536ab8fd7f98e93eb05aa904c5ab420b81cf90a6db6546b08fc2c638c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d454b44eab812a59dbfda071f00e0f5d7af7c530d4676bd5d2179fb336474e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end

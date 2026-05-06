class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.8.tar.gz"
  sha256 "3f457fd19858486dcfdb6f860a889f8be3df63e7568da2bbd96e8b434dae1d92"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c859f62d16b17364f78f98a360e8d961f77463df1edee30bdca20e5819d8b3ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c859f62d16b17364f78f98a360e8d961f77463df1edee30bdca20e5819d8b3ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c859f62d16b17364f78f98a360e8d961f77463df1edee30bdca20e5819d8b3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5cadeca9318dd1a13c37aca8385feae6cbf2b25b30eb01ced729cf85c018c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dcb82a00d0366162b2b599af4ef3a9d909b00084a9427ab9013499b4f1f6a8b"
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

class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "e54550636613f44aa0286f52fe8dc90e7b006f9795b1f568ab91884bb5d5af6b"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8f8270d887cdbd4da8f4f126420c8e61d510aa57a950dc59027c7c85e711dd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f8270d887cdbd4da8f4f126420c8e61d510aa57a950dc59027c7c85e711dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8f8270d887cdbd4da8f4f126420c8e61d510aa57a950dc59027c7c85e711dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57dd103a86161271ab312303d82fcfe74d978eb570b4b39678567db3163393af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48d7d499d0129f2edc9f94457e72b62ca230b15ecec8057459149c60d4d2f671"
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

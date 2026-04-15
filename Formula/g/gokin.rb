class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "87df2ff91ddfce6c90c43726477dfc5cf0eea44b7fc90faf40f9c85a0c642059"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b24bf1f4a0a74e5fb7854eeb8a4252f0e1de497fc447ba8b20c3b473627dbbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b24bf1f4a0a74e5fb7854eeb8a4252f0e1de497fc447ba8b20c3b473627dbbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b24bf1f4a0a74e5fb7854eeb8a4252f0e1de497fc447ba8b20c3b473627dbbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90951497df9419ec333e65ba24d8a021b40109b70807fe5627740513aa4e4b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd63e784e903b1492c11e06957be8fe96b7bede320a3e4afd816c55303fbab77"
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

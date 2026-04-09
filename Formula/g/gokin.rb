class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.59.4.tar.gz"
  sha256 "637c4afe28c955e2e818421b126ace9782e8fc398e2ba81ed5e0686b48a8db3d"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "100d6c7ff7e2ccebb815c035121811bb51a1a24d5871fb1176a5a8246cecd82c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100d6c7ff7e2ccebb815c035121811bb51a1a24d5871fb1176a5a8246cecd82c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100d6c7ff7e2ccebb815c035121811bb51a1a24d5871fb1176a5a8246cecd82c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d9bfd140ad6957e2620d4666d0096d8adcf38388ccbfd9ee684a6fc85b8022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7902649cdae78943a0f2e80baceb58dc25465144224d3eeccbe9ef7704002380"
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

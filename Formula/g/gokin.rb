class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "613e87f88fc5995c3f89f1be575f0f69c38dd6f17b56862c2ebce68f8c17ae77"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fcf43d90b3fdf5d898ddb58fc3ed5e43dc3dcf878de57894dd1e26e95eda162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fcf43d90b3fdf5d898ddb58fc3ed5e43dc3dcf878de57894dd1e26e95eda162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcf43d90b3fdf5d898ddb58fc3ed5e43dc3dcf878de57894dd1e26e95eda162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42cefaea1e4121c114ae57df3ae7d62a8e89460fe3476a00479446da19019212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf09fba9f196cbf484bc051bd4bada423fbb475f0e9952d075519132681ea8c0"
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

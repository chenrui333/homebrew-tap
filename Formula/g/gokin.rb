class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "613e87f88fc5995c3f89f1be575f0f69c38dd6f17b56862c2ebce68f8c17ae77"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9a5794afdfa8580bedd48d7dd3d7d0ebd69b6a368a6e9e6a89058558bcfe31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b9a5794afdfa8580bedd48d7dd3d7d0ebd69b6a368a6e9e6a89058558bcfe31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b9a5794afdfa8580bedd48d7dd3d7d0ebd69b6a368a6e9e6a89058558bcfe31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4247fbc56bae309338535e8dc77ea05c072eed3e3047232754ca3524bc200a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8993f3704c4b949eb637bdc74aa6b154a0f7be71aefc84be9e63b113705e747"
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

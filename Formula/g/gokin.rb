class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.84.tar.gz"
  sha256 "a8d1c7c836c21a0b4a824cf5d672c0dc3c38b52bea237d34dd425943b21e0c99"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "725b52ecbd2f9dc1044828ce3d5d73d107fb62c1591e1e92a9b90e8f48ca5b9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725b52ecbd2f9dc1044828ce3d5d73d107fb62c1591e1e92a9b90e8f48ca5b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "725b52ecbd2f9dc1044828ce3d5d73d107fb62c1591e1e92a9b90e8f48ca5b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a587707d97ba8ad790168ae8d702d9356ac45012066a26dc88a04ceb68715c2c"
    sha256 cellar: :any,                 x86_64_linux:  "473052e35cc661fd330ca76ea59210366392a7c761992f5c6514947e8317325b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end

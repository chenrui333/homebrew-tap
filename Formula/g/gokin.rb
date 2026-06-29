class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.55.tar.gz"
  sha256 "e8fb1bb5005570a8b71e39ddcb6791888d9fc4da66bdea874085d83d9c2366f0"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336f73900936f7bc060466f0ea271766a0f75d4623a42f7932cef82c25fa92df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336f73900936f7bc060466f0ea271766a0f75d4623a42f7932cef82c25fa92df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336f73900936f7bc060466f0ea271766a0f75d4623a42f7932cef82c25fa92df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ef67feafc79b088e9610ec3bdee146d3ae8badb88f441bce15c94505563fee"
    sha256 cellar: :any,                 x86_64_linux:  "0dd22ae57e44ecd367f8fdb2594138648d9e25d1387ea0084c8e67d4cf48e75e"
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

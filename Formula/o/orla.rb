class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "22b618b8935d238f79916683591b59cdcc256d3cb712c52692a8ce96d9508a89"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fe3178a31cffa58a2325b1a93d959a8dd19048ace8aa5138eb4e3b8fe79c021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe3178a31cffa58a2325b1a93d959a8dd19048ace8aa5138eb4e3b8fe79c021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe3178a31cffa58a2325b1a93d959a8dd19048ace8aa5138eb4e3b8fe79c021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a891b7567d3fbb14719bfafb79373c41674b1d5165e5a0168d150e8dd300c2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2371ae3b1f809a4dd72216aff3630809584e93987a09a8c7be1fa1fc913eab42"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "Start orla's agent engine as a service", shell_output("#{bin}/orla serve --help")
  end
end

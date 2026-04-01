class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "4722f30fe564c7443fe5e0857e99cc4ceb62e7cfa7b33628beb7b228f842e4b1"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feb0ce68152b83b9fa1c10bf088606c2019b6951481d7661b8e95bbe5587a5e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37837a389fdf1551cc22e3f9c1d2b6119a1c6f2dc55510dc95254a42d672900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5409f3dfe014844e769e796ffa9aab6fa2967e4585bf77aec7bbb742ff28005d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd688072ce7d9502806d03401a101854cd7b0371e743572eeefb6e2a2a6ae6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61982a743cf93ea384e8aaaf6a7ea05bc68f373e66b43e2ef6cfc526d3abced4"
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

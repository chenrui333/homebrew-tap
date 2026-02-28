class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "46dbd7b06cf8e26190bb0b0975c0a1e6eabefce9b1eb651766879b924425d4d1"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3330392843c831b61f925677af4d9cd122d855ab79c1f3b422f66c05da2580c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3330392843c831b61f925677af4d9cd122d855ab79c1f3b422f66c05da2580c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3330392843c831b61f925677af4d9cd122d855ab79c1f3b422f66c05da2580c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78a681f564f3353c572accddfd9e068c145bea854ccd3c61371a444d6422fd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e465903d8064cb5c737ace6a368b342e822f7a0f93ebfc970fb21d252a7cb4f6"
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

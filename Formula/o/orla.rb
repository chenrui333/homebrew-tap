class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "1af6cf9f4b04f3d1a75cae0269e917e833c24093e8b903bf11b4768c7410f5fc"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57387d5f6ec46dc97b85bea007e0eaeca147f77b42070f7d849cf644c138414f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0451baa2b9ddf1740fcdfe4c4a72ddd8d3262bceda5bec46c3718fd092735be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36158a6a371cc91a6d9ca5dd361410154a7fcd74e134b035de033995f14ed0c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01157fbc9e30bb6e9c2bc9314d0f40a6bcb3e889a14d69349c8dfb9d5dd90e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b5f435fee865c7ae71b2e23976bd94e27c52be15341f5600b479bfbec2858d"
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

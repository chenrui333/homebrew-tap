class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "1af6cf9f4b04f3d1a75cae0269e917e833c24093e8b903bf11b4768c7410f5fc"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a58316c1323da7955b96b9f4ac9f3c19863430acae34dd5170adecb3a40ca20e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894214afb171d4e4dc2ecd260d1de911ad80e4430a173a6903a1c3e50c142b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e8127e9e14eeedf43de0abcbdb24776d7e793d03c17a95f61da16fb8c916144"
    sha256 cellar: :any,                 x86_64_linux:  "92d3478ae26d4fc79e617fc6a9c8253f2ce7925c0f57ed3fa052e0acf321aaf6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    require "open3"

    output, status = Open3.capture2e(bin/"orla", "serve", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

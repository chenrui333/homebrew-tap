class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "fa1a98bfbbf48a09b55b32a65c9789a6c30ac61f516ca3309d1511bece793a42"
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
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    require "open3"

    output, status = Open3.capture2e(bin/"orla", "serve", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "52c6a88ae4070d953f31d862a7d1668143358eb12666d323e8dbafa915d0ea0f"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2fa2ab0fc4f28d6ae8fb8f0f83255d93db71f6659662af6c8a7c2beccdaae78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45eeb368e37828d5579cb6032add9d0e52156f20de032bf46bb6a90a058dbab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac5a437fa175f8489dc9ded7f0f78223db6404464e726853feec0382a744de0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ddaac3a37f4d7f0ef5f7c588a8c828521f9d078bbdc0e18d14573582d31d6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6971d0479b0059d01e0f209f7ca3e9e6fb206fbe895d6f66175c6ca661319ed4"
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

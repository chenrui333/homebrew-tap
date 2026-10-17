class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "4a854f7b380696ada35b538d9207a529cfb23e5b1fc87d0282979fc7fbbb745e"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05219f91ab0ac7113f095f48fbac640368a9108d1f68cca6a91d88d68746fad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05219f91ab0ac7113f095f48fbac640368a9108d1f68cca6a91d88d68746fad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b1a9377869e0b227e322f0ae6440d3582fea9927c209967a9347a4771a3242"
    sha256 cellar: :any,                 x86_64_linux:  "970e97e9b0902e325a1c796d3b30ddce7a53449415b24abeb3e69ebd491ddb7b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end

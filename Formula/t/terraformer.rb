class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.13.tar.gz"
  sha256 "c8367a5d23643dee6b35884c8f559985a61ddbc9146c97035538753abd444d16"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5642044741fa692f3b65d8b80c86133706db5cbede1b87750d6af56cdbb7183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5642044741fa692f3b65d8b80c86133706db5cbede1b87750d6af56cdbb7183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5642044741fa692f3b65d8b80c86133706db5cbede1b87750d6af56cdbb7183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "806049bc39f5e438059233e82bcd39f4de7efe499a348ec517cb290698f35b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "337dfce669e7d558d9cf68b1eb2f49e114bd99812e9123bee8108b84b852f606"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/chenrui333/terraformer/version.Version=#{version}
      -X github.com/chenrui333/terraformer/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraformer version")
  end
end

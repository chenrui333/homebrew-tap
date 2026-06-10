class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.13.tar.gz"
  sha256 "c8367a5d23643dee6b35884c8f559985a61ddbc9146c97035538753abd444d16"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178c84baf9aca800e4a9e1ae055f66fd00a8ad24366216f0a79e7721b8d88e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178c84baf9aca800e4a9e1ae055f66fd00a8ad24366216f0a79e7721b8d88e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178c84baf9aca800e4a9e1ae055f66fd00a8ad24366216f0a79e7721b8d88e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "921d4193afc7749aee2c923c9cfeb169d87e5f2b164efa9195f20aec3a3ee53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cba508155fe8e79627a92a2129efb06513622e352c5495dd0e288700d704f10"
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

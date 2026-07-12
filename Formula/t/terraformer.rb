class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.15.tar.gz"
  sha256 "4ae3ec44ae9cb9372881eeb9e6fe85531e8205f3db2bacf9dd594d1a9a675313"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9c021481ccbdcc0c2a044d722857f2fe039ab1a8bbd58333e54c01f21e5a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9c021481ccbdcc0c2a044d722857f2fe039ab1a8bbd58333e54c01f21e5a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c9c021481ccbdcc0c2a044d722857f2fe039ab1a8bbd58333e54c01f21e5a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8343dd55b0d0ab3127930a7b8952f653bbd9ab4043b235cd619afd008b060c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4fa0cef85c7eecec98fe534ca9c74a6d28d31a758eb44bd45e4eb43ebbf558a"
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

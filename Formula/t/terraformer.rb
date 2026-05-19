class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9ce9ac8ea51966cd7c016185c988372fa35be4653d4fe220724649094deaa490"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac29ec3f574744a1aee87f9a17b9ad2d8c64a61ad1fd6f71ff368b45dfbf9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc22e9888c8fb43fd1123b46d24df1dc748f752f8e8e652e637e75e6e385a51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bed30d52c19e9863a98b7eb5af8cecd75e426604d7dff547cd57bd9383834e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79deb07b2d0faf14c6afdb7aadb5586bc1e15bee511c5a11d62b6c3d12eb47db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d506f51a8dc4117ac9c217754e860e0d720e24df4250e37c66b039fe9af8bd"
  end

  depends_on "go" => :build

  def install
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

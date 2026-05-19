class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9ce9ac8ea51966cd7c016185c988372fa35be4653d4fe220724649094deaa490"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

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

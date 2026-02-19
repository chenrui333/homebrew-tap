class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "31429fd7aa95440509850e174bc932b7d33aed8be687d90904129c95f73da715"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38103548e5934019968ff918097cdb250640c4c5c46fa087155b8734b5fa780c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d62392d220f058ff68a98caebcaab76760379afcdaed616e42a03443f5731e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091a001f15af1c01553764f536f6940efa46eef958a84cf6566520f7569cccc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1618c24775541dd2fc64bbd9df740fa4564f67400db803b94986fb828d0d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627bfd9473830c1ffd464d96cdb80dde3aa2a1409d473d05d535131339800644"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v3/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end

class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.1.1.tar.gz"
  sha256 "fce7422b0525cde6d3d8f8da8e4f9d357f3fd7f1d37be46db456f593b2c8aa76"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7ca57f5e29f7fa4c4d7928af8756432569ed457f2ccadb36e16909c2029d5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ca57f5e29f7fa4c4d7928af8756432569ed457f2ccadb36e16909c2029d5d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ca57f5e29f7fa4c4d7928af8756432569ed457f2ccadb36e16909c2029d5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a00a8e7960ed11d8e9e62ea1da57efccc57c7c1082ec63924a1845be38e64266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a742fabe563d9476c202f45b499f4ce492a87fb89c747a85bed451285c91c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end

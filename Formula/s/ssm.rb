class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.1.1.tar.gz"
  sha256 "fce7422b0525cde6d3d8f8da8e4f9d357f3fd7f1d37be46db456f593b2c8aa76"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e118ce904f7129abf31d8132c33a1d0347a8ae430b599a8d2f11fc56954321ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e118ce904f7129abf31d8132c33a1d0347a8ae430b599a8d2f11fc56954321ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e118ce904f7129abf31d8132c33a1d0347a8ae430b599a8d2f11fc56954321ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dbca971cbda55a19c26bd55f8b9f9b90ebf7a38178f7807d27f955e0e37a81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488b340505836d23bf22b5fe414f40c4b2a1f609d57c0c798bf175efe5def17d"
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

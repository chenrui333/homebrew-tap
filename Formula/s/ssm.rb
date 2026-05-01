class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/1.0.1.tar.gz"
  sha256 "1eee49031df043db03000d7ce9d993538da3f2e641a3c8a810ed77176984b3fa"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd260bb941619e8e9e9ac259e19578cfa74146d7da91040057e863a80d3ac41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd260bb941619e8e9e9ac259e19578cfa74146d7da91040057e863a80d3ac41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd260bb941619e8e9e9ac259e19578cfa74146d7da91040057e863a80d3ac41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc67a3ed8f5d994d89e175cddb13c048296378124b7b26945efdc82fd8a74836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5df17af58684a15e16af97a6736bb3105a0a2386e452ad4c506633f8d1d2f8"
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

class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "dd6dbf9afb6aee84e0523ecd5635abd7f2b77cda4dc07e1e480714ef7b26adad"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd3d8061f67395fa05a7d854b24f9ba197483e025a58072e3fd5c171bba53a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd3d8061f67395fa05a7d854b24f9ba197483e025a58072e3fd5c171bba53a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd3d8061f67395fa05a7d854b24f9ba197483e025a58072e3fd5c171bba53a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b8fcef94dfbecbba6afd49e0bd87069738ab550344733c82f8c52ccbdf063bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b2410c62bb21e3f19ccb2a7705dca9a54b840135baf376c1c8a1829e8957a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end

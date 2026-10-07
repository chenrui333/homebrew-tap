class Urlhunter < Formula
  desc "Recon tool that allows searching on URLs that are exposed via shortener services"
  homepage "https://github.com/utkusen/urlhunter"
  # GitHub regenerated the v0.2.0 archive (same tag commit); pin the tag commit
  url "https://github.com/utkusen/urlhunter.git",
      tag:      "v0.2.0",
      revision: "39f2051895b95f93f1dadeba2cfd235d920f945e"
  license "MIT"
  head "https://github.com/utkusen/urlhunter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b9694f154f5ca94ca5cd64956cbe5a57687831044c0ac57dd0057c08f817d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b9694f154f5ca94ca5cd64956cbe5a57687831044c0ac57dd0057c08f817d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2756fb74ace0fcdeccba75866b54e7a51488e42926c7af72225719e75475ff03"
    sha256 cellar: :any,                 x86_64_linux:  "4605da9b5efbc4e008332520e1920223f1b1e083c1a54c5d7257e103a12dc12d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/urlhunter --keywords #{testpath}/keywords.txt --date 2024-13-01 2>&1", 2)
    assert_match "[ERROR]: Wrong date format!", output
  end
end

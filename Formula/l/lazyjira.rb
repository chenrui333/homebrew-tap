class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "0b05ad3b0723bfd952914eb39c5f5334b234bce249a2802c912fd244ba219585"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63fe8b97d36fe934591a310aaa79bda0167a84e4f58ed38a5e8204a2e640b19b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63fe8b97d36fe934591a310aaa79bda0167a84e4f58ed38a5e8204a2e640b19b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63fe8b97d36fe934591a310aaa79bda0167a84e4f58ed38a5e8204a2e640b19b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78681622898b45afcbaaa21d17a88902de0c615be8e373b3e2a797420922444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad351885a9a728232d138ab532fdc0dd5e9d7370316929f80e5602fdf9cf55b"
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

class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "9b45872a6c283c9695e14d8db9d7006b4b5fd8157b44c03f81c5b83dfce7d521"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f9118cc3adde3e1812d9e606ffb723e4f813e7620b83fa7cd1a43fcca56a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f9118cc3adde3e1812d9e606ffb723e4f813e7620b83fa7cd1a43fcca56a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f9118cc3adde3e1812d9e606ffb723e4f813e7620b83fa7cd1a43fcca56a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8e3459f19fb652bf45d7d4bf58e26b7b1859bca9aa74e05345365c0846f152d"
    sha256 cellar: :any,                 x86_64_linux:  "f5f8c8f5babe41f35c071d3649ab9181d5cf866d1207232eeb5d54997af33c05"
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

class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "0b05ad3b0723bfd952914eb39c5f5334b234bce249a2802c912fd244ba219585"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca39bf7e7eb27df0c5aa13ccca1c246a720b280689730f17ec7dc02da8152b62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca39bf7e7eb27df0c5aa13ccca1c246a720b280689730f17ec7dc02da8152b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca39bf7e7eb27df0c5aa13ccca1c246a720b280689730f17ec7dc02da8152b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c44eb0d0f07f7142b7ee64a561176899c51dae7cd7613ce29caf6122c947675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6da2a794b50bd9730693fe45a5ab84fe7bcfd90d625f3ee224e9b43ac5a8580"
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

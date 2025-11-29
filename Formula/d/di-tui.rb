class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "cd8abe4d3f0e49ac83fb45058c2579dd939fa2156685c052b41235e978907baa"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21f29aebb281df006bd0a928d6f4b1933961f1bc6d5aa266a821517dce63122d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f29aebb281df006bd0a928d6f4b1933961f1bc6d5aa266a821517dce63122d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f29aebb281df006bd0a928d6f4b1933961f1bc6d5aa266a821517dce63122d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0194e22c8631f03c2dc54638e89401ddc1e4847ad360638115d8a185b2822c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a109bfc36f809e002c56e325952dda8e91f2594ff131936aaebdcd7d71a87f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")

    output = shell_output("#{bin}/di-tui --username USER --password PASSWORD 2>&1", 1)
    assert_match "unable to reason API response", output
  end
end

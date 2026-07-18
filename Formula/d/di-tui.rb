class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "983d845bd1c3a05a9a355313e430d92cb143929192df7ca69810a9e0849b745f"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01a29925e29df7237c6dcc4950c3b176ea87a006f8422eb3adf1f5f089f704a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01a29925e29df7237c6dcc4950c3b176ea87a006f8422eb3adf1f5f089f704a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01a29925e29df7237c6dcc4950c3b176ea87a006f8422eb3adf1f5f089f704a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37d14ea6f266532b6b585dab357adc1dc91c45df3697c197b15d29cf54d6182"
    sha256 cellar: :any,                 x86_64_linux:  "1a5e5a95b1e6ed7ccc9c4578a31b69f7bb7f072c71d6c2a3f487dcce2e04db12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    output = shell_output("#{bin}/di-tui --not-a-real-flag 2>&1", 2)
    assert_match "not-a-real-flag", output
  end
end

class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "12fb90dcaea96bfb906b65e00e925a54ceb22045b3ca96f82b92dbc8e5481097"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78853efa182b759dac59cb5219aee19f0013d12729325202084326b9b6b38c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78853efa182b759dac59cb5219aee19f0013d12729325202084326b9b6b38c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78853efa182b759dac59cb5219aee19f0013d12729325202084326b9b6b38c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "334e1b6a8d867c2b55b61bdd747e84582663d8823a33188077a855c05aa14a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd57a1b9d0100c47deb0fea794733ac8de12a7efd7737681d6104e4f6d45f3e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    assert_match "Usage of", shell_output("#{bin}/di-tui --help 2>&1", 2)
  end
end

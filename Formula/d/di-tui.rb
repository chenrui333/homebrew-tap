class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "c51a19ba85a3370ffe13caba0967eebb61a3f3202a761d624640622778e62dfc"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "864795ef4daab6861675a0551e8c39ab64ab40813a556618ad06445d009ba3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864795ef4daab6861675a0551e8c39ab64ab40813a556618ad06445d009ba3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864795ef4daab6861675a0551e8c39ab64ab40813a556618ad06445d009ba3d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22852b7c54fb2b6378c091c3b13840ee4b2cec749381c9f7ada1e38d0da38d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ea52547d48134495aa0b4e1ae372682d19abe970c6e0814fcfc2a7ad79bd25"
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

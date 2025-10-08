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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05136ba5c475d7b08731a8a469e92d43c5af27efdd50b89ce89ca286f9e6ac84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1187a040b713e74ec6cf3dea8bc31d1751653ebad7d079e5e45d02b86d3ef7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a19865fa5cd2b5a2d27563e5ed504fa306dab7fd35421f5496666026ca854d"
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

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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ea2d4a093bf08560b9b85afa761ea479b3afc2b3ef7c3308e254c91569fdd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ea2d4a093bf08560b9b85afa761ea479b3afc2b3ef7c3308e254c91569fdd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ea2d4a093bf08560b9b85afa761ea479b3afc2b3ef7c3308e254c91569fdd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e87e2fb699aaf7acc5e9039d2476d0bcd1ade970fce6d37cc0adc97a60fefee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b011f91ceae2ea6ec5ce44954fbac5fda03d83f3d6f5954f8d3264eb4ea20cff"
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

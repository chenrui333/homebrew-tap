class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "94c4b29951ad4ac28c99817105e8e123ba645de1ad3ff2f26db8171893b5124f"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b283938970b6729c0e5a4eb84dbdac78d4ae6b62faccc3e2a82545705e1c7a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b283938970b6729c0e5a4eb84dbdac78d4ae6b62faccc3e2a82545705e1c7a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b283938970b6729c0e5a4eb84dbdac78d4ae6b62faccc3e2a82545705e1c7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd12c2c945ced4e2a0afce7e1a0e9667023ff17437a2d36b372e60e0b953403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a612b56315709dcfb2586b81c8b4b0c62996c801d665bc08826f2cc9764408"
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

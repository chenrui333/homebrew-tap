# framework: cobra
class Gowall < Formula
  desc "Fetch GitHub user information and show like neofetch"
  homepage "https://github.com/Achno/gowall"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gowall", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end

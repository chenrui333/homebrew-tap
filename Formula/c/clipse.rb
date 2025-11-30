class Clipse < Formula
  desc "Configurable TUI clipboard manager for Unix"
  homepage "https://github.com/savedra1/clipse"
  url "https://github.com/savedra1/clipse/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a265b16505ef6ab45259d2daf8fbb4b13f18c8231a7deb70b08936fce759c29e"
  license "MIT"
  head "https://github.com/savedra1/clipse.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clipse -v")

    test_string = "Homebrew clipse test"
    system bin/"clipse", "-c", test_string
    assert_equal test_string, shell_output("#{bin}/clipse -p").chomp
  end
end

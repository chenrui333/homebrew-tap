class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b13cf66f2af080c9ea46ed86e6616cfd4766f4c57c925e29fde9f1ac29b4e044"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", "completion")
  end

  test do
    assert_match "Failed to build the vgo tool", shell_output("#{bin}/vgo build 2>&1")
  end
end

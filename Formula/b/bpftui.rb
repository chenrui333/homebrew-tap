class Bpftui < Formula
  desc "Interactive TUI for browsing BPF programs and maps"
  homepage "https://github.com/viveksb007/bpftui"
  url "https://github.com/viveksb007/bpftui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7bceb2c4fae5a3da5f282ac8338b3873df2ffbd846abc8d49d82e5f6cb96bf2c"
  license "MIT"
  head "https://github.com/viveksb007/bpftui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "097e3e053f1f675d22d091cbba91c55f2e05c8debd6723b675b39876c31c8b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "56483c0a6a5173241144f40292959ffa751e4d837a2d35c1b0bea2efcb733763"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/bpftui 2>&1", 1)
    assert_match(/bpftui|tty/, output.downcase)
  end
end

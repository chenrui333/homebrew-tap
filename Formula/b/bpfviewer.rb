class Bpfviewer < Formula
  desc "Developer tool for disassembling and visualizing BPF object files"
  homepage "https://github.com/tsint/bpfviewer"
  url "https://github.com/tsint/bpfviewer/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "2677fa2e687b572fd1ded4ce101aee1829edba393018c6c744cc0446a7ff3bad"
  license any_of: ["Apache-2.0", "MulanPSL-2.0"]
  head "https://github.com/tsint/bpfviewer.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "version", shell_output("#{bin}/bpfviewer --version")
  end
end

class Bpfviewer < Formula
  desc "Developer tool for disassembling and visualizing BPF object files"
  homepage "https://github.com/tsint/bpfviewer"
  url "https://github.com/tsint/bpfviewer/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "2677fa2e687b572fd1ded4ce101aee1829edba393018c6c744cc0446a7ff3bad"
  license any_of: ["Apache-2.0", "MulanPSL-2.0"]
  head "https://github.com/tsint/bpfviewer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c429b3f7b50928c8daaa3fea9932117341b74d367b55de6230fce4e19c3718d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c429b3f7b50928c8daaa3fea9932117341b74d367b55de6230fce4e19c3718d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c429b3f7b50928c8daaa3fea9932117341b74d367b55de6230fce4e19c3718d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c62f89751433e7f9424042812ef36dafba512a9ee735ada2b19b5d9f1be2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3656932dd19a918e0c1ef1bdf9f4e48881c06124c4f4666b7167a767a5b407e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "version", shell_output("#{bin}/bpfviewer --version")
  end
end

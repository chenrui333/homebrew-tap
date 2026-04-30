class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "f22ed1f11594958102e7ef1b46fdfaf16aeedcecae5c2ef30b520892eb331d4e"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0576d3f60d7d508c1c92167b4df6dfeb01528065dd630472fe74c9d31c576e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dca05d06775abce97e0ec683f0d887b396b68f3f25dae6ea5229a07a0283c9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20db6e26443a030f926a6035497d4b134b7cda1c57c06d43a8f512a77b27b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "962edda23bf7f24551383da4bff1f4903673f8f83cd0b0126030b37d9d627779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d977101a64bdf183af75318569c912a9e6283664b7ebb3ed26bfe3434a43ecd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end

class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "9cf401397975a883f5e1c1c4e48bd7704acaafe099907f3c6ffbb1f25f2ee09a"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83050143573eefc648875a18960d1c9acbd19ae1376469a07332a2e5952f328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364d33d9ea702b859eb244c23842d7279b9b800a9396d47b4234feb6a33a07f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6730ffc73dd1ce6247932d87431281cd2f789286f1bf584056b97d23acefbfef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a93ac9a2e1b076ab29d17c8cabc692fb4bc98e96af6659cef2aa9c60398395a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548d9a6235b97bca1b6d5427d87d4a785c9405be88be4da2f1315e9a87a55d55"
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

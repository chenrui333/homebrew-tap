class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "a6ce6a15b8c6fff57656b70d8eb1750ca114244383a7e37fc63c0f5ac4c5edaf"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1209a9829c7980969168f9a7ae01014ce1f74f1a4e77829e6736ea5e4539224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4f139899fd86fdd6d7704387973403f678c303a2a6ee49a0b6a4e24ccb52c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fba2fce8305dc18a59fbfc16e97735d8db8b8e284dee70edea2411f4d32f00"
    sha256 cellar: :any,                 arm64_linux:   "1163ef2b6b5314a718d47321d5a98d4ad9817dd278d9c7f939b142ee7cbc0eb5"
    sha256 cellar: :any,                 x86_64_linux:  "d9c6ca62735d08c3938f444ee0d1ab75fdf86eb9f99cacee43ffa7e77cc5bbb3"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end

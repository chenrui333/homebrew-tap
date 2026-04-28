class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "6ca330a3b7c70137f6026d49673c36a0b8306adeebffc628505752c140767ace"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "900c92cf0857b80c404dbf04bc75b432531f32115dcbc739c34931f02cb60968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb0550dacaf145a5adfee13671f4c2d1ec9e6a22a1e1b8efcd9ed307ed93ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b021b27287f40a8b280eeff558234fe3c0bd213619cefc69eb97fcdaf3ba08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b401c6a2cc0f104973320a842e3fb18a0f38b43942a074885fcc474a1df7ede0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f55afacd0746bc95c0b643a7a63a3374b1abbeb5f7d5bb6cf19c492fd4504e"
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

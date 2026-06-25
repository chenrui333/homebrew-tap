class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "50eebb10194fe76c60c8e510ac4564034e4143029d6754589f2543db87669b8c"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ba549b0707ef4bcbdbd680651749c561b12692b8cf53cbfb1f44bd3f049d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a62b244461183c5a95b69a93b9eb3ed20cd2bc8e59e20159c465113885ebef69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7310bfe9c5641d937416f38c780f49002e6707eb7a274d96c8226ee7da4c1449"
    sha256 cellar: :any,                 arm64_linux:   "2219abec733aa2ab09d97c8d8ebc4b899c2a6bcf4d98bacad44da761fa66e404"
    sha256 cellar: :any,                 x86_64_linux:  "294fcf259e63dcd5199ee862df6c0708b516473bebc38d25ad9bbdbfdbcfd259"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    # Upstream's jemalloc background_thread setting warns on macOS.
    inreplace "zerofs/.cargo/config.toml", ",background_thread:true", "" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "zerofs")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zerofs --version")

    system bin/"zerofs", "init"
    assert_match "ZeroFS Configuration File", (testpath/"zerofs.toml").read
  end
end

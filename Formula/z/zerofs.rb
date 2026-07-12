class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "2bac84891f7dfa4ef379088c6ebc0794251bed60c3a0d6afb15ca1cfdb313881"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557b92d40c4200490b6e176ff30c2bf2647f612149212ca1092d64175483312a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "299e1f9cd4548991ebb1ed8f47e05f02390e854e0e47caa95ddbab6f00e5aaad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27293b3cafdd56b5b41498c1e73bbae4b756575a4a883234411dee66f0ed73be"
    sha256 cellar: :any,                 arm64_linux:   "bdd686f0ff21339371e325a65dedd67640c20652994fb23a8b4557a0ff9d42e4"
    sha256 cellar: :any,                 x86_64_linux:  "206998f86ee444e05f8a1af71c35a7a42d57baee259dea001263c73b14c86961"
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

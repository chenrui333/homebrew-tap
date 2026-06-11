class Bttf < Formula
  desc "CLI tool for datetime arithmetic, parsing, formatting and more"
  homepage "https://github.com/BurntSushi/bttf"
  url "https://github.com/BurntSushi/bttf/archive/refs/tags/0.1.4.tar.gz"
  sha256 "21b265959403c02406137adac1012f676a25ad67d6fbf29a553b9e459c7bbc73"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/bttf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a02626a37587fcd189be846fb28a5acf82d084adb543004c3160c0cd0ce8a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a4689226a8f34d9ce2375e7f852d8b36b0c0e8600d5d2117e8508505f5c66c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a88c89f22599f3db65f54223323f3f09c57ec3e4129a50bf996025c6a05e31a"
    sha256 cellar: :any,                 arm64_linux:   "13745823617e2fbc51b286b253827cdfa628c64c52b4ffb14be4cded03607695"
    sha256 cellar: :any,                 x86_64_linux:  "53ee8e6a09223c3e9961b8fc69cdd0caa334a4b66d9f2f26e23a2256c1506a5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bttf --version 2>&1", 1)
    assert_equal "2026-06-11\n", shell_output("#{bin}/bttf time fmt -f '%F' 2026-06-11")
  end
end

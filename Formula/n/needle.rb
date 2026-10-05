class Needle < Formula
  desc "TUI that highlights the GitHub PRs that need you"
  homepage "https://github.com/cesarferreira/needle"
  url "https://github.com/cesarferreira/needle/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "21a0762ce4c77939b28c3ede0772e1eb980a4ab8869eb90da720fd969851c32a"
  license "MIT"
  head "https://github.com/cesarferreira/needle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55ca4d0f448f8113330af198ebde8f042c46bf4e6866a3f34fc12ff3fcbb9f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d8318be9c8cdfefd63195eb37fc2a6db8a2a504cb2ac48b3c283eca9fdd602"
    sha256 cellar: :any,                 arm64_linux:   "2b4954b23ef9e322c318c6c1bf31e8c95331d8fab4a74f0ed170f64475daecc8"
    sha256 cellar: :any,                 x86_64_linux:  "87a58e36e053eee5e835c4347945b15f85e33e15f4ad7850e6668cc06d2247ac"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle --version")

    output = shell_output("#{bin}/needle --demo 2>&1", 1)
    assert_match "Not a TTY", output
  end
end

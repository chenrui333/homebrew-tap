class Qwe < Formula
  desc "File-first atomic version control system"
  homepage "https://mainak55512.github.io/qwe/"
  url "https://github.com/mainak55512/qwe/archive/refs/tags/v0.3.3-a.tar.gz"
  version "0.3.3-a"
  sha256 "262d28a522ad6ce4998ac4a16d4130b50c01f03875b0d3ff51ca9325a0ba2eb5"
  license "MIT"
  head "https://github.com/mainak55512/qwe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3451915a606cfb1b8e077b21b3388e5d43070c5397deccb0341fe6edf184a84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3451915a606cfb1b8e077b21b3388e5d43070c5397deccb0341fe6edf184a84b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a6be5c80884704f359970572a32b23bf658bc63def0e8aa1135158ccdbacfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a4780d00883fd4f46b5ea08edf6cac800b42f40238b39ad8010f05b7501295"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    system bin/"qwe", "init"
    assert_path_exists testpath/".qwe"
    assert_path_exists testpath/".qwe/_tracker.qwe"
    assert_path_exists testpath/".qwe/_group_tracker.qwe"
  end
end

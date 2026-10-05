class Narr < Formula
  desc "Download audio tracks from Netflix to sample your favorite shows"
  homepage "https://github.com/IljaN/narr"
  url "https://github.com/IljaN/narr/archive/refs/tags/0.2.0.tar.gz"
  sha256 "f5913c56d842ba37802fa792a30d8fbe10a608d8a3133a1d593ccc9a22b70f02"
  license "Unlicense"
  head "https://github.com/IljaN/narr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "949daed33b660890bade065834d69330073255e16f734f6769ed3d6d6cb1679a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949daed33b660890bade065834d69330073255e16f734f6769ed3d6d6cb1679a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82de443d951f7191e71632ad4c00d0085887f11b26b9c7a7885b020888a77a9"
    sha256 cellar: :any,                 x86_64_linux:  "73ea8c3e3813a6d6cc964fd7516765d7ed043aa27f82b0c1dba516f4a2d817f7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/narr --version")
    output = shell_output("#{bin}/narr --not-a-real-option 2>&1", 255)
    assert_match "not-a-real-option", output
  end
end

class Narr < Formula
  desc "Download audio tracks from Netflix to sample your favorite shows"
  homepage "https://github.com/IljaN/narr"
  url "https://github.com/IljaN/narr/archive/refs/tags/0.2.0.tar.gz"
  sha256 "f5913c56d842ba37802fa792a30d8fbe10a608d8a3133a1d593ccc9a22b70f02"
  license "Unlicense"
  head "https://github.com/IljaN/narr.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    system bin/"narr", "--help"
  end
end

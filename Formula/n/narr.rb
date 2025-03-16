class Narr < Formula
  desc "Download audio tracks from Netflix to sample your favorite shows"
  homepage "https://github.com/IljaN/narr"
  url "https://github.com/IljaN/narr/archive/refs/tags/0.2.0.tar.gz"
  sha256 "f5913c56d842ba37802fa792a30d8fbe10a608d8a3133a1d593ccc9a22b70f02"
  license "Unlicense"
  head "https://github.com/IljaN/narr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55588064fdcf6855d96007fe0fe028f0b3cfa2015f06738d39f508f9418e55e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "171cef9aab1471cb03a6143040b07b8a48a95189cc225f4257ec924bee45730f"
    sha256 cellar: :any_skip_relocation, ventura:       "df721cd5f0041c11cc23776db898cf445c7413868cd43229089ce17588287725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c619e145de302f2587927209edadbbabb6ddde348d8e8a1cd80babaeaba12bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    system bin/"narr", "--help"
  end
end

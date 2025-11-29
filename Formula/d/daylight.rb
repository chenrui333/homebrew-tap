class Daylight < Formula
  desc "Track sunrise and sunset times in the terminal"
  homepage "https://github.com/jbreckmckye/daylight"
  url "https://github.com/jbreckmckye/daylight/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "369ce9dd5299a68febbae38278efdef9cc2a8e8a2d1934ac42e352dece2ff6e9"
  license "GPL-3.0-only"
  head "https://github.com/jbreckmckye/daylight.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70d9a509cc06d1cf59c1fc22534af8d924606114500e48ea24ebc97fa4e73dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d9a509cc06d1cf59c1fc22534af8d924606114500e48ea24ebc97fa4e73dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d9a509cc06d1cf59c1fc22534af8d924606114500e48ea24ebc97fa4e73dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5e23c540fc3f7aa80fbc65cf7b96ed658ec84441cf035a91dd24269413113a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50481318cbf7585fcaeb78cbfa041032e87f3403da180899b86f54322fd30a3d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    ENV["NO_COLOR"] = "1"
    assert_match version.to_s, shell_output("#{bin}/daylight --version")
    assert_match "Ten day projection", shell_output(bin/"daylight")
  end
end

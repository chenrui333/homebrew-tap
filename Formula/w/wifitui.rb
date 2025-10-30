class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "ba9dcf1dffc76c573f2f9c5dc0965e3b29c2723fb9fc5e54c27592fd6b15eadb"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a187bf72b6c374a8ba568c4ae4376387bcf29183f5d14b0c1a0403858696a2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a187bf72b6c374a8ba568c4ae4376387bcf29183f5d14b0c1a0403858696a2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a187bf72b6c374a8ba568c4ae4376387bcf29183f5d14b0c1a0403858696a2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf61346edf04dfc991ce9e54f4c8de4994f810a3d63e0a50a97df7a782ebd8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0ea3fa84e7dcebf3afd9d7cdd4916b9b73a44a3030e754929b54f31d06417f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = OS.mac? ? "no Wi-Fi interface found" : "connect: no such file or directory"
    assert_match expected, shell_output("#{bin}/wifitui list 2>&1", 1)
  end
end

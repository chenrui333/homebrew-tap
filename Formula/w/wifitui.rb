class Wifitui < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7cefb600618122e08e2c4569b9162a94931a65758fc01be2280b08c9be978b67"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785b6698e4ac56101b6440360bdd3231456197e6ce9f3eb0c9f6bb3b039b107e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaee268f4cd701d73abd53bc7a911ff137c7516f38f04429a73afa846840664b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8aa9521edc369b2ff41b816c5943cfe1df4e1e4d5a43ca093eb3977cb42284"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = OS.mac? ? "no Wi-Fi interface found" : "failed to list networks"
    assert_match expected, shell_output("#{bin}/wifitui list 2>&1", 1)
  end
end

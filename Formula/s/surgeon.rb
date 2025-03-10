# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4d4d81e82d5dc3373603c422e7209ec37821a5c00846b3d86526fe88a2d7ad6d"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd4d2edeb49cb99b4c3cd5b90d1cc186f8e08e52619b228afbdd477817e382e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5796c4cebe874b464f43ef9a3017dca6999ab72195c43981889e52c8695b91a"
    sha256 cellar: :any_skip_relocation, ventura:       "3a790f481a18bbe2c3789ba3505e3d6a779532e1f21b512fe07c8cfd22638269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc1c5f7c41a6390277caf0f0c1a6a620e389c26d7b9f960bbba1e125f795f6b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end

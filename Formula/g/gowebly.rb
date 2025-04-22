class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "1da53a9784d2031b63a84f28230dcb6f3e0b803922f91782d16164129bc2c19b"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20e3c59c7db7238a417dc839a9a844cce9705143fb13f2fb01cddc4db17140d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5c4de4ca4a00b1aec5018cd04dc48d57551c99c396540060e0c3d635a9e5cd"
    sha256 cellar: :any_skip_relocation, ventura:       "7d44d517177eb15de47faa5987bfabdea8fd93a7b4bf8479f3d3d983d5a9da9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c788f5c3ef31f94de717b01a1af61bfb0477e2c0c79b1c17778a52632b0921e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end

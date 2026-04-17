class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.8.tar.gz"
  sha256 "7af9cf5e9f67477a5d6996c8579c2334d8921c817bdcbebd9f45a63e85dc3a7b"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825d9ecc9ab3a8a96f0bb02e66f813b793245f03c56c6267f1510de3d65b3508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fda517797b46ccc004e1b22ae5abd20e8946f8a3aa581f154328ee5d4aa41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0343d71efaa0f49031b42f750286227711977781cc09ddfae8494add924f5401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd012f52e29c40e1ff0c9e5589902feba8233775674a565af88036d28457b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475a13b3d348be8abfddfbdd0fe7d513dec586b890f48127f22bff7697a41cc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} 2>&1", 1)
    assert_match "no services configured", output
  end
end

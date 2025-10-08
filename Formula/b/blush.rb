class Blush < Formula
  desc "Grep with colours"
  homepage "https://github.com/arsham/blush"
  url "https://github.com/arsham/blush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6db6b033bb5d4c4ac350b36b82d79447d5b91509db3a5eceb72ecb9484495e54"
  license "MIT"
  revision 1
  head "https://github.com/arsham/blush.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06bf30af4fa379fb0743773ed96c650876086a807a19cd8b40fb133807bf730c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06bf30af4fa379fb0743773ed96c650876086a807a19cd8b40fb133807bf730c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06bf30af4fa379fb0743773ed96c650876086a807a19cd8b40fb133807bf730c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55e42a9d76081b4d12b8157a1de4c50b25655972968bf64fd5c34de6ab121fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa81fbebaff23335cba4c4a914d3decae53777b1e2e1f063605aa8e96eaadc40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    pipe_output("#{bin}/blush -r test", "brew test\n", 0)
  end
end

class Pencode < Formula
  desc "Complex payload encoder"
  homepage "https://github.com/ffuf/pencode"
  url "https://github.com/ffuf/pencode/archive/refs/tags/v0.4.tar.gz"
  sha256 "90a7ed8078eddbc2afdefa193a4c3e5d2fd85ece447c47149e53a4c10d495a87"
  license "MIT"
  head "https://github.com/ffuf/pencode.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b9803fe7151115456e7e216c9b46936c63d7e1f97b50e05818731506d4d822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6b9803fe7151115456e7e216c9b46936c63d7e1f97b50e05818731506d4d822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "182df129a5f9ee0be6024af4ecde31227549a7a957d2ed0ddb41c038189db857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c4bf0b1e21d9d48604172caf2d7bdbfff897cd84ac887a74d7c78e0c66f122"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pencode"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "dGVzdA==", pipe_output("#{bin}/pencode b64encode", "test")
    assert_match "test", pipe_output("#{bin}/pencode b64decode", "dGVzdA==")
  end
end

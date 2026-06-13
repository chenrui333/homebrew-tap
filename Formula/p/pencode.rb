class Pencode < Formula
  desc "Complex payload encoder"
  homepage "https://github.com/ffuf/pencode"
  url "https://github.com/ffuf/pencode/archive/refs/tags/v0.4.tar.gz"
  sha256 "90a7ed8078eddbc2afdefa193a4c3e5d2fd85ece447c47149e53a4c10d495a87"
  license "MIT"
  head "https://github.com/ffuf/pencode.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90fb59e65239d7aa7cef71a6c4a3fc0174878adc7d35b064792eeb792c07c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90fb59e65239d7aa7cef71a6c4a3fc0174878adc7d35b064792eeb792c07c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90fb59e65239d7aa7cef71a6c4a3fc0174878adc7d35b064792eeb792c07c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e895136f45d3c1fa9b70e1e6b8b9643b015d919dce9747b3fe79b37cce5d7832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398bbcbf3b0aae287f4e752c9ea07fe9cb88ea6f43595179dc632a59e232b4ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pencode"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "dGVzdA==", pipe_output("#{bin}/pencode b64encode", "test")
    assert_match "test", pipe_output("#{bin}/pencode b64decode", "dGVzdA==")
  end
end

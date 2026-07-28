class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "10fbaf94ba00f687500a1e99b9b6446bea4d49135b44867a5a461c75864ba742"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff0b9047d702982d06440183d5d7226fbd46f001af975286bf7695c66afc4672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0b9047d702982d06440183d5d7226fbd46f001af975286bf7695c66afc4672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff0b9047d702982d06440183d5d7226fbd46f001af975286bf7695c66afc4672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d054a5a045297481ff239284618fee2fd0830781415ad2ab07b8377ffdc1361"
    sha256 cellar: :any,                 x86_64_linux:  "19d292407d74ed7aa2b0d8f13e1000bd6601fc6c84dc18c79601658c0e482143"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
    cd "client" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/trdl"
    end
  end

  test do
    ENV["TRDL_DEBUG"] = "true"
    ENV["TRDL_HOME_DIR"] = testpath.to_s

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/trdl list")
    assert_match "Name", output
    assert_match "Default Channel", output
  end
end

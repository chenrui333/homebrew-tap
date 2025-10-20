class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "dc6b99f20b1ab33f6801050a2367529a235c2b1a654d24f908b1f1bf62a36457"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

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

    assert_match version.to_s, shell_output("#{bin}/trdl --help")
    output = shell_output("#{bin}/trdl list")
    assert_match "Name  URL  Default Channel", output
  end
end

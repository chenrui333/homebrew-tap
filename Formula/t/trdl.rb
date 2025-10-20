class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "dc6b99f20b1ab33f6801050a2367529a235c2b1a654d24f908b1f1bf62a36457"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3d1927079724fc072b698a7b9ccc9319c2f9e72307f9d77335c8909d4d7965d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d1927079724fc072b698a7b9ccc9319c2f9e72307f9d77335c8909d4d7965d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d1927079724fc072b698a7b9ccc9319c2f9e72307f9d77335c8909d4d7965d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6bfd2df8f390618681d0515d7471dfd9341a2fd1490267a2340490db9c55d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af6c7df18d6e2404a2bb72cfa7a9e394fccc9bf187af529a027db283a9ab787"
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

    assert_match version.to_s, shell_output("#{bin}/trdl --help")
    output = shell_output("#{bin}/trdl list")
    assert_match "Name  URL  Default Channel", output
  end
end

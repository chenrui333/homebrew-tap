class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "1d87f09909a1c2efa8cd1e5abc35201ea1fd72fde0e74f1b8d1d5f60f8dc7c4b"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22f9a672d78a1396c7832ec3ccce63afa6142ed51296b42d055b86f81773e829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f9a672d78a1396c7832ec3ccce63afa6142ed51296b42d055b86f81773e829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22f9a672d78a1396c7832ec3ccce63afa6142ed51296b42d055b86f81773e829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bd5ccee3499a7bc26edfa6ccfe494f221d77ac306c83cb8bdbeb30f2d201057"
    sha256 cellar: :any,                 x86_64_linux:  "00569137edd98ea36df4edaf52406a588cd3097d58b080dd4e6b90b4d2e0a685"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end

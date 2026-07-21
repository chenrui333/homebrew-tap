class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "1d87f09909a1c2efa8cd1e5abc35201ea1fd72fde0e74f1b8d1d5f60f8dc7c4b"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c2a8aa53313f8763ecda59eff36c68089ab4fadce3e24dd2b7a4963f3f86844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2a8aa53313f8763ecda59eff36c68089ab4fadce3e24dd2b7a4963f3f86844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2a8aa53313f8763ecda59eff36c68089ab4fadce3e24dd2b7a4963f3f86844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f135f1c0e376cd37059e087e50524c31a8c4d1a0a513b1f175d9f404a76ff79"
    sha256 cellar: :any,                 x86_64_linux:  "5af87538686db2c8e67114e8add99e55f75efa62af1f5e0eaed2ac653c6d1ae3"
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

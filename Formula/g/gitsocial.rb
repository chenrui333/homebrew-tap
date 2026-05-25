class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "6e3aaedb070be9b1f3cc3b265a9d712fc0abc7b8f562b9c50ed31cafd8855bfd"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e86ddf02bad43234ccdae937a6b7f65ab02dee45ce05d4a5c17a820c502d02a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e86ddf02bad43234ccdae937a6b7f65ab02dee45ce05d4a5c17a820c502d02a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e86ddf02bad43234ccdae937a6b7f65ab02dee45ce05d4a5c17a820c502d02a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dfbd2c8551c5c30d604bce5721e77cb6329d50bf0592b7edc9aa0c186db18e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8bd2ffb27e810d91f65656aa1f02a0166bd1931b6f68a60506b4d76b01af9a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end

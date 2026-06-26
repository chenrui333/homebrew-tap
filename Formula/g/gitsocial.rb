class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "3ff8a20c13b4161ac1711a606fb67dc4307acbad658d682951dc6a2e22ce7e2f"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f19d3cacde801a01ef6a88eaa75fe95f1487bf8b87313d4c95599faede8c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7f19d3cacde801a01ef6a88eaa75fe95f1487bf8b87313d4c95599faede8c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7f19d3cacde801a01ef6a88eaa75fe95f1487bf8b87313d4c95599faede8c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4e2b3d017c6768c541b0e75431cf77bc7c458acc975ec4dad4109dee59f794"
    sha256 cellar: :any,                 x86_64_linux:  "d5920d0231ab945daf3fe4730e16f765370f9601bc7a0e0690efa3dfab3952f3"
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

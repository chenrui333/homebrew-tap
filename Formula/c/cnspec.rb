class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.4.1.tar.gz"
  sha256 "4d8b29050cb69b7eddb0f681032d7d5c35a918e166b4acd80dc7ad5d97d89399"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22176c8321ece03cc915aeaecc24bb2dec9b7fc7aebdef64f6a55b9b10fd1599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1818e8b96850ee66731d173f62f9a4cdb4735701a3c899b32502d53c91776ef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5657bda693f7b5c4c2dd6f401ce3f1c3c989af43d372ff9bd44032a65da02cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88501554a0f1b727751401f56d694f9a556568f1c6cca07bda96bd6dfa9b97b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ed7402a28d2dd4d84ee25c24cb4422f5c2dc63115f56103051a96b56a0f1b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end

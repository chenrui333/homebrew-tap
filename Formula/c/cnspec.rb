class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.17.0.tar.gz"
  sha256 "b52005d34ced91f96c6b3c02f7cf0e34ee68513c8ad676f8ac934bbe9f87dd10"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09d34826cc79237bf13bb61083ae63307e620f344f4234003d70d0789948e324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3355fc44c9ee42164673d8dd76f6e8cac82cb195ceb881a6538bc9c7ff215a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9b061546b99c30132d46c48728464ebe72626fe7704d62f980ef56f4f4c7a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1725ce279c456161a046883c95235946277243a9914711bdbc8fdf2281a427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74af2f62d53c7ecbe57f7494eada29d6545da28f62ec2d249ce2d7314bac5f54"
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

class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.7.1.tar.gz"
  sha256 "9baada35c893b94124c5e488e5dbf211de0b747030238dd638b15b202b0889f9"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a13f251143c72f3d3cbeee8021f00faf7983cecaeff6de1b3c5b855203ea1ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a46aef16897714bae71e63ec3514883dc7587952b979998985d4ba78415b48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac316c4205c4e50903d61b9f6c27466d76f4c3cb7ba0d867c9ef704342c72fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572ba27c26778a5cab565851e64eb0341772d2feab5467018aa5f9b2c87d5acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4aacdd3e764a6355f6d0cb91ce948ee553ffc8fae337a70a415304976054124"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end

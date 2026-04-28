class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.7.0.tar.gz"
  sha256 "e4fed3fa5b87c6c187b4509e87551860ee164f094932dfa3c9b76bcf1065c83f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f9f7a80cc855f7649f8c4b51836b432e0a2b6e993bd88e4e19346988c5ff4c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e3ec2993060cc94993ba9941898f3c1a4f76d847bac9585eb34ed49006f8fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb763b30a56c482154e6f03ef6ce2ac9fd11aebd921754cadc3e529a47dfec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513ddde73fb8d538df577a79b615469b854601b03a719e781317fcc1835a96e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37aa443cad67c1cf11af9c7902c23a1b9c72dfdb8baaa23552eca01fed51c165"
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

class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.18.0.tar.gz"
  sha256 "be76679cd5a85e2baf8d470c6dd11f33c549aeb9cc110339fb20f5cef55851a4"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c290eef6ff2c79f98e242f6dc0cc8e66498873ddc63304c69a5f3fed3838be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d49ee135fe2ed425a418410d33f2aadbb3546e7401a53990098c7a66a4ed8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e9a3e3d6cf8120d3507e032d8da9257891554ac5490ba9e713a8411ace81642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff09b4b0ceaf51079c02f0729fbf246b832cb1c5a0d0e0667fa5b1c5de03c0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5285faa0beae8b0da73a165c0c80669dde8eb78a29447c92ccc0e57867f3745"
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

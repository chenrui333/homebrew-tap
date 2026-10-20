class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.8.0.tar.gz"
  sha256 "0f066650bea59506b2ef41bbe43eb5c41daf178def40e00d6940c0008b1c759d"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff3b6db60ac982d7fc029a528f196aae8aa58125b3c2e59ce0e8c8b6dbec4b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92dc3b63c13e83b262b589ac356429f7145c343ef33f54b1492668eb3792478c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "360a0c0c702a4be7303b47113d1e689ec717721908bd6330599b3c8a1baad12e"
    sha256 cellar: :any,                 x86_64_linux:  "967e6be94e854bf68585d38668fda301e0a7446f20f295980d7a07cbb0207b34"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end

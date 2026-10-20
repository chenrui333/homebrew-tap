class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.8.0.tar.gz"
  sha256 "0f066650bea59506b2ef41bbe43eb5c41daf178def40e00d6940c0008b1c759d"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "016e7e4f841b1a0f1aa9e2ce8a8fc288adf5b70d616c1a2a3f17b9672d719674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c123909099e8e23180cfa419fba07c5f4490c191cdeff9377b1227b56522aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c791a900266b36369daa86a4ccb38e1fa21f43f0a9c3e5d8cb9d55a54eb5533"
    sha256 cellar: :any,                 x86_64_linux:  "b9b3fa0be85b2bb373b23fe05a82f45a214e3ed4e0b9e3ad1ed2089ffcef392e"
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
